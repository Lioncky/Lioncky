#!/bin/bash
# box auto update to /usr/bin/bx 
# https://github.com/Lioncky/Lioncky/tree/main/sh
#
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: shbox-2025-0922
# Version: 0.0.5 
#======================================
${Font_suffix}"

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

is_nums() {
    local targetnum="$1"
    if ! [[ "$targetnum" =~ ^[0-9]+$ ]]; then
        return 1 # Failed return ! 0
    fi
    return 0 # Success return 0
}

first(){
	
	apt update -y
	apt install  -y git tmux screen nano vim curl net-tools wget sudo proxychains iperf3 lsof conntrack openssl unzip lsb-release jq ca-certificates bash-completion iptables netcat-openbsd && update-ca-certificates
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/tcping.sh)
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/bashrc.sh)
	git clone https://ghfast.top/https://github.com/iiiiiii1/doubi.git
	git clone https://ghfast.top/https://github.com/hulisang/Port-forwarding.git
	git clone https://ghfast.top/https://github.com/vpsxb/EasyRealM.git
	git clone https://ghfast.top/https://github.com/seal0207/EasyRealM.git
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/P3TERX/script/master/speedtest-cli.sh)
	apt install python python3-pip -y

}

doc(){
	wget -qO- get.docker.com | bash
}

proxy(){
	select_proxy
	set_proxy
}

select_proxy(){
	echo -e "${Info} 选择需要安装魔法: \n1.multi-v2ray\n2.x-ui\n3.docker版x-ui\n4.docker版v2ray(需自行修改配置文件)\n5.docker版xray(需自行修改配置文件)"
	read -p "输入数字以选择:" kxsw

	while [[ ! "${kxsw}" =~ ^[1-5]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" kxsw
		done
}

set_proxy(){
	[[ "${kxsw}" == "1" ]] && multi-v2ray
	[[ "${kxsw}" == "2" ]] && x-ui
	[[ "${kxsw}" == "3" ]] && x-ui-docker
	[[ "${kxsw}" == "4" ]] && v2ray-docker
	[[ "${kxsw}" == "5" ]] && xray-docker
}

multi-v2ray(){
	
	source <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/Jrohy/multi-v2ray/master/v2ray.sh) --zh

}

x-ui(){
	
	bash <(curl -Ls https://ghfast.top/https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

}

x-ui-docker(){
	docker run -itd --network=host -v /root/x-ui/db/:/etc/x-ui/ -v /root/x-ui/cert/:/root/cert/ --name x-ui --restart=unless-stopped enwaiax/x-ui:latest
}

x_ui_install(){
	x-ui
}

v2ray-docker(){
	mkdir -p /root/v2ray
	wget -O /root/v2ray/config.json https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/config-v2ray.json
	docker run -d --network host --name v2ray --restart=always -v /root/v2ray:/etc/v2ray teddysun/v2ray
}

xray-docker(){
	
	mkdir -p /root/xray
	wget -O /root/xray/config.json https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/config-xray.json
	docker run -d --network host --name xray --restart=always -v /root/xray:/etc/xray teddysun/xray

}

hc(){
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/jcnf.sh)
}

ihc(){
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/ijcnf.sh)
}

tcpx(){
	bash <(curl -fsSL https://ghfast.top/https://git.io/JYxKU)
}

ddxt(){
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/hiCasper/Shell/master/AutoReinstall.sh)
}

nfcheck(){
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/check.sh)
}

yabs(){
	bash <(curl -fsSL yabs.sh)
}

lemonbench(){
	curl -fsSL https://ghfast.top/raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/LemonBench.sh | bash -s fast
}

superbench(){
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/superbench.sh)
}

speed(){
	curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/superbench.sh | bash -s speed
}

io(){
	curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/superbench.sh | bash -s io
}

ipcheck(){
	curl ip.p3terx.com -4
	curl ip.p3terx.com -6
}

tz(){
	bash <(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/cokemine/ServerStatus-Hotaru/master/status.sh)
}

jg(){
	bash <(curl -fsSL https://ghfast.top/raw.githubusercontent.com/Aurora-Admin-Panel/deploy/main/install.sh)
}

xd(){
	bash <(curl -fsSL https://sh.xdmb.xyz/xiandan/xd.sh)
}

lnmps(){
	select_alternative
	set_alternative
}

select_alternative(){
	echo -e "${Info} 选择需要安装的lnmp: \n1.宝塔\n2.LNMP\n3.oneinstack\n4.aapanel"
	read -p "输入数字以选择:" lnmp

	while [[ ! "${lnmp}" =~ ^[1-4]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" lnmp
		done
}

set_alternative(){
	[[ "${lnmp}" == "1" ]] && bt
	[[ "${lnmp}" == "2" ]] && lnmp
	[[ "${lnmp}" == "3" ]] && oneinstack
	[[ "${lnmp}" == "4" ]] && aapanel
}

bt(){
	bash <(curl -fsSL http://download.bt.cn/install/install-ubuntu_6.0.sh)
}

aapanel(){
	wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
}

lnmp(){
	apt update -y && apt-get -y install wget screen #for Debian/Ubuntu
	wget http://soft.vpser.net/lnmp/lnmp1.9beta.tar.gz -cO lnmp1.9beta.tar.gz && tar zxf lnmp1.9beta.tar.gz
	rm zxf lnmp1.9beta.tar.gz -rf && cd lnmp1.9
	screen ./install.sh
}

oneinstack(){
	apt update -y && apt-get -y install wget screen #for Debian/Ubuntu
	wget http://mirrors.linuxeye.com/oneinstack-full.tar.gz -cO oneinstack-full.tar.gz
	tar xzf oneinstack-full.tar.gz && rm oneinstack-full.tar.gz -rf
	cd oneinstack #如果需要修改目录(安装、数据存储、Nginx日志)，请修改options.conf文件
	screen ./install.sh
}

update_debian(){
	bash <(curl -sSL https://ghfast.top/raw.githubusercontent.com/wikihost-opensource/linux-toolkit/main/system-upgrade/debian.sh)	
}

auto_update_bx(){
	echo "install... /usr/bin/bx" #mv /root/shbox.sh /usr/bin/bx
	curl -fsSL -k https://ghfast.top/https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/shbox.sh -o /usr/bin/bx && chmod +x /usr/bin/bx && bx
}
x_hihy(){
	curl -fsSL -k -o /usr/bin/hihy https://ghfast.top/https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/az/hihy.sh && chmod +x /usr/bin/hihy && hihy
}
x_aabt(){
	wget -q --no-check-certificate -O /usr/bin/aabt https://ghfast.top/https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/az/aabt.sh && chmod +x /usr/bin/aabt && aabt
}
x_ovpn(){
	wget --no-check-certificate https://ghfast.top/https://raw.githubusercontent.com/Nyr/openvpn-install/master/openvpn-install.sh -O /usr/bin/ovpn && chmod +x /usr/bin/ovpn && ovpn
}

ps_ef(){
    read -p "输入进程标识符: " pnames
    if [ -z "$pnames" ]; then
        echo "❌ 进程标识符不能为空"
        return 1
    fi
    ps -ef | grep -i "$pnames" | grep -v grep
}

port_check(){
    read -p "输入要检查的端口: " nums
    if ! is_nums "$nums"; then
        echo "❌ 请输入数字端口号"
        return 1
    fi
    lsof -i:$nums
}

port_to(){
    read -p "输入要转发的本地端口: " nums
    if ! [[ "$nums" =~ ^[0-9]+$ ]]; then
        echo "❌ 请输入数字端口号"
        return 1
    fi

    read -p "输入目标IP: " addr
    if ! [[ "$addr" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "❌ 请输入正确的 IPv4 地址"
        return 1
    fi

    read -p "输入目标端口: " targetnum
    if ! [[ "$targetnum" =~ ^[0-9]+$ ]]; then
        echo "❌ 请输入数字端口号"
        return 1
    fi

    # 开放本地端口
    ufw allow ${nums}/tcp

    echo "🔀 转发规则: 本地 ${nums} → ${addr}:${targetnum}"
    nohup socat TCP-LISTEN:${nums},fork TCP:${addr}:${targetnum} > /dev/null 2>&1 &

    echo "✅ socat 已后台运行 (PID=$!)"
}
proc_kill(){
    read -p "❌输入要杀死的进程名称: " pnames
	pkill $pnames
	ps -ef | grep $pnames
}
x_help(){
	echo -e "\033[96m\napt install"
	echo -e "端口占用: lsof -i:5090"
	echo -e "端口转发: apt apt install socat -y"
	echo -e "\tnohup socat TCP-LISTEN:3080,fork TCP:1.2.3.4:3306 > /dev/null 2>&1 &"
	echo -e "curl -x socks5://127.0.0.1:10808 https://ip.eoeg.cc/1.2.3.4"
	echo -e "\033[33m"
}

check_root

echo -e "${Info}选择你要使用的功能: \033[95m \033[92m\t0.帮助  \t 00.自我更新 Ya~"
echo -e "[安装]1.一键Hy\t 2.宝塔aapanel_zh\t 3.OpenVPN\t4.[x-ui]\t5.端口转发socat\t"
echo -e "\033[94m 6.yabs测试\t 7.全网测速\t 8.读写IO测试\t 9.流媒体测试 \t\n"
echo -e "\033[95m11.端口占用\t 22.端口转发\t 33.查找进程\t 44.杀死进程\t 99.本机IP(3322)\n"

echo -e "\033[33m61.首次运行\t 62.安装docker\t 63.安装bbr\t 64.魔法上网\t 65.回程路由(TCP)\t 66.回程路由(ICMP)"
echo -e "\t 68.superbench\t69.lemonbench\t  33.探针安装"
echo -e "34.本地IP\t 35.极光面板\t 36.闲蛋面板\t 37.DD系统\t 38.建站环境\t 39.升级Debian(自动执行谨慎操作)"
echo -e "\n\033[93m请选择:\033[0m"
read -p "" nums

	if	  [[ "${nums}" == "0" ]]; then x_help
	elif [[ "${nums}" == "1" ]]; then x_hihy 
	elif [[ "${nums}" == "2" ]]; then x_aabt
	elif [[ "${nums}" == "3" ]]; then x_ovpn
	elif [[ "${nums}" == "4" ]]; then x_ui_install
	elif [[ "${nums}" == "5" ]]; then apt install socat -y
	elif [[ "${nums}" == "6" ]]; then yabs
	elif [[ "${nums}" == "7" ]]; then speed
	elif [[ "${nums}" == "8" ]]; then io
	elif [[ "${nums}" == "9" ]]; then nfcheck

	elif [[ "${nums}" == "00" ]]; then auto_update_bx
	elif [[ "${nums}" == "11" ]]; then port_check
	elif [[ "${nums}" == "22" ]]; then port_to
	elif [[ "${nums}" == "33" ]]; then ps_ef
	elif [[ "${nums}" == "44" ]]; then proc_kill

	elif [[ "${nums}" == "99" ]]; then curl http://ip.3322.net  # show ip

	#首次安装
	elif [[ "${nums}" == "61" ]]; then first
	elif [[ "${nums}" == "62" ]]; then doc
	elif [[ "${nums}" == "63" ]]; then tcpx
	elif [[ "${nums}" == "64" ]]; then proxy
	elif [[ "${nums}" == "65" ]]; then hc
	elif [[ "${nums}" == "66" ]]; then ihc
	elif [[ "${nums}" == "68" ]]; then superbench
	elif [[ "${nums}" == "69" ]]; then LemonBench
	elif [[ "${nums}" == "33" ]]; then tz
	elif [[ "${nums}" == "34" ]]; then ipcheck
	elif [[ "${nums}" == "35" ]]; then jg
	elif [[ "${nums}" == "36" ]]; then xd
	elif [[ "${nums}" == "37" ]]; then ddxt
	elif [[ "${nums}" == "38" ]]; then lnmps
	elif [[ "${nums}" == "39" ]]; then update_debian
		
	else
		echo -e "${Info} 输入无效" && read -p "输入数字选择:" nums
	fi
