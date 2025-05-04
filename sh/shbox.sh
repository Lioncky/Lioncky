#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: shbox
# Version: 0.0.3
#======================================
${Font_suffix}"

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
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

lb(){
	
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

x_shbox(){
	curl -fsSL -k https://ghfast.top/https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/shbox.sh -o /usr/bin/bx && chmod +x /usr/bin/bx && bx
}
x_hihy(){
	curl -fsSL -k -o /usr/bin/hihy https://ghfast.top/https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/az/hihy.sh && chmod +x /usr/bin/hihy && hihy
}
x_aabt(){
	wget -q --no-check-certificate -O /usr/bin/aabt https://ghfast.top/https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/az/aabt.sh && chmod +x /usr/bin/aabt && aabt
}

check_root

echo -e "${Info} 2025-050332: "
echo -e "${Info} 选择你要使用的功能: \033[33m"
echo -e "0.自我更新\t 1.首次运行\t 2.安装docker\t 3.安装bbr\t 4.魔法上网\t 5.回程路由(TCP)\t 6.回程路由(ICMP)"
echo -e "7.流媒体测试\t 8.superbench\t 9.yabs测试\t 10.LemonBench\t 11.IO测试\t 12.全网测速\t 13.探针安装"
echo -e "14.本地IP\t 15.极光面板\t 16.闲蛋面板\t 17.DD系统\t 18.建站环境\t 19.升级Debian(自动执行谨慎操作)\n"
echo -e "\033[96m80.本机IP3322\t 81.一键安装Hy\t 82.一键安装宝塔aapanel_zh\033[0m\n"
read -p "请选择:" nums

	#while [[ ! "${nums}" =~ ^([0-9]|1[0-9]|8[0-9])$ ]]
	#	do
	#		echo -e "${Error} 缺少或无效输入"
	#		echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" nums
	#	done

	if   [[ "${nums}" == "0" ]]; then x_shbox  
	elif [[ "${nums}" == "1" ]]; then first
	elif [[ "${nums}" == "2" ]]; then doc
	elif [[ "${nums}" == "3" ]]; then tcpx
	elif [[ "${nums}" == "4" ]]; then proxy
	elif [[ "${nums}" == "5" ]]; then hc
	elif [[ "${nums}" == "6" ]]; then ihc
	elif [[ "${nums}" == "7" ]]; then nfcheck
	elif [[ "${nums}" == "8" ]]; then superbench
	elif [[ "${nums}" == "9" ]]; then yabs
	elif [[ "${nums}" == "10" ]]; then lb
	elif [[ "${nums}" == "11" ]]; then io
	elif [[ "${nums}" == "12" ]]; then speed
	elif [[ "${nums}" == "13" ]]; then tz
	elif [[ "${nums}" == "14" ]]; then ipcheck
	elif [[ "${nums}" == "15" ]]; then jg
	elif [[ "${nums}" == "16" ]]; then xd
	elif [[ "${nums}" == "17" ]]; then ddxt
	elif [[ "${nums}" == "18" ]]; then lnmps
	elif [[ "${nums}" == "19" ]]; then update_debian
		
	elif [[ "${nums}" == "80" ]]; then  curl http://ip.3322.net  # show ip
	elif [[ "${nums}" == "81" ]]; then  x_hihy 
	elif [[ "${nums}" == "82" ]]; then  x_aabt
	else
		echo -e "${Info} 输入无效" && read -p "输入数字选择:" nums
	fi
