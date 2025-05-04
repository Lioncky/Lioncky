import vdf
import sys
import json
import winreg
import asyncio
import aiofiles # pip install aiofiles
import aiohttp  # pip install aiohttp
from pathlib import Path
from typing import Dict

'''
Dep:
  pip install aiofiles
  pip install aiohttp
'''
# Configs
PROXY_URL = "https://ghfast.top/"
THIRD_PARTY = "SteamAutoCracks/ManifestHub"

# SteamConfigs
STEAM_PATH = Path(winreg.QueryValueEx(winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\\Valve\\Steam"), "SteamPath")[0]) 
CONFIG_VDF = STEAM_PATH / "config" / "config.vdf"

# steam/config/config.vdf
depot_vdf = []
 
depot_data = [
  ("1659421", "54f1e37db693643220de1240ebc50a0c00d4bc3a53ffdd91cf3f52cc71c91382"),
  ("1659422", "513eb93ddc7de41caabd6dfc7f8b2f5da716cc75ca9df1df674e4e339fceada2")
]

async def http_request(url: str) -> Dict: 
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as resp:
                resp.raise_for_status()
                return await resp.json()
    except Exception as e:
        return {}


async def http_download(path: str, url: str) -> bool:
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as resp:
                resp.raise_for_status()
                content = await resp.read()

                async with aiofiles.open(path, mode="wb") as f:
                    await f.write(content)
              
                return True
    except aiohttp.ClientError as e:
        print(f"❌ HTTP 请求失败: {e}")
    except Exception as e:
        print(f"❌ 下载或保存文件时发生错误: {e}")
    return False

async def get_depotkeys_file() ->str:
    file_path = Path.cwd() / "depotkeys.json"
    if file_path.exists():
        print("✅ depotkeys.json 已下载")
        return file_path.read_text()

    url = "https://ghfast.top/https://raw.githubusercontent.com/SteamAutoCracks/ManifestHub/refs/heads/main/depotkeys.json"
    print("⏬ depotkeys.json 不存在，正在下载...")
    if not await http_download(file_path, url):
      sys.exit(1)
    return file_path.read_text()


async def update_depot_keys(depot_keys):
    async with aiofiles.open(CONFIG_VDF, "r+") as f:
        content = vdf.loads(await f.read())

        steam_config = (content.setdefault("InstallConfigStore", {})
          .setdefault("Software", {})
          .setdefault("Valve", {})
          .setdefault("Steam", {})
        )

        steam_config.setdefault("depots", {}).update(
          {d_id: {"DecryptionKey": d_key} for d_id, d_key in depot_keys}
        )

        await f.seek(0)
        await f.write(vdf.dumps(content, pretty=True))
        await f.truncate()



async def main():
  print(f"✅ VDF_Inited:{CONFIG_VDF}")

  app_id = input("请输入AppID: ")
  # app_id ="1716740"
  i = int(app_id)
  print("✅ AppID:\n\t", i + 1)
  print("\t", i + 2)
  print("")

  depot_data.clear()
  depot_keys = json.loads(await get_depotkeys_file())

  if mainifest := depot_keys.get(str(i+1)):
    depot_data.append((str(i+1), mainifest))

  if mainifest := depot_keys.get(str(i+2)):
    depot_data.append((str(i+2), mainifest))

  if not depot_data:
    print("❌ 未找到指定AppID的清单")
    sys.exit(1)

  print(depot_data)
  if data := await http_request(f"https://api.github.com/repos/SteamAutoCracks/ManifestHub/branches/{app_id}"):
    if isinstance(data, dict):
      depot_cache = STEAM_PATH / "depotcache"
      print(f"✅ 清单已连接: {data["commit"]["sha"]} {depot_cache}\n")

      if tree_content := await http_request(data["commit"]["commit"]["tree"]["url"]):
        for item in tree_content["tree"]:
            file_path = str(item["path"])
            
            if file_path.endswith(".manifest"):
              
                depot_id, _ = file_path.split("_", 1)
                if depot_keys[depot_id]:
                  print(f"✅ DepotKeys...ok: {depot_id}")
                  depot_vdf.append((depot_id, depot_keys[depot_id].upper()))
                  
                save_path = depot_cache / file_path
                if not save_path.exists():
                  print(f"✅ 开始下载...manifest: {depot_keys[depot_id]}")
                  if await http_download(save_path, f"{PROXY_URL}https://raw.githubusercontent.com/SteamAutoCracks/ManifestHub/{data["commit"]["sha"]}/{file_path}"):
                    print(f"✅ 下载成功...manifest: {save_path}")    
                else:
                  print(f"✅ 已下载...manifest: {save_path}")

        print("✅")

        if depot_vdf:
          await update_depot_keys(depot_vdf)
          print(f"✅ config.vdf 已更新: {CONFIG_VDF}")
        print(f"✅ steam.db参见: https://steamdb.info/app/{app_id}/depots/?branch=public")    
        input("✅ 感谢您的使用 miku~, 按下任意键继续...\n")

asyncio.run(main())


# https://ghfast.top/https://api.github.com/repos/SteamAutoCracks/ManifestHub/branches/1672970 <-appid
