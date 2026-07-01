#!/bin/bash
# box auto update to /usr/bin/bx 
# https://github.com/Lioncky/Lioncky/edit/main/sh/shbox.sh
#
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Info="${ColGreen}[Info]${ColNone}"
ColGreen="\033[32m" && ColRed="\033[31m" && ColNone="\033[0m"
Error="${ColRed}[Error]${ColNone}"
ERR_NOT_NUM="❌ 输入0-9非法,请检查"
VER="9.2"
echo -e "${ColGreen}
#======================================
# Project: shbox-2026-0207
# Version: ${VER}
#======================================
${ColNone}"

auto_update_bx(){
	if [ ! -e "/usr/bin/bx" ]; then
		x_pre_install
	fi
	echo "install... /usr/bin/bx" #mv /root/shbox.sh /usr/bin/bx
	curl -H "Cache-Control: no-cache" -H "Pragma: no-cache" -fsSL -k https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/shbox.sh -o /usr/bin/bx && chmod +x /usr/bin/bx && bx
}

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

is_nums() {
    local targetnum="$1"
    if ! [[ "$targetnum" =~ ^[0-9]+$ ]]; then
		echo ${ERR_NOT_NUM}
        return 1 # Failed return ! 0
    fi
    return 0 # Success return 0
}

x_block_ip() {
    local ip=$1
    local BLACKLIST="/var/blockip"
    
    # 如果没有传入IP，则交互输入
    if [[ -z "$ip" ]]; then
        read -p "请输入要拉黑的IP: " ip
    fi
    
    # 简单验证IP
    [[ ! $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && echo "无效IP" && return 1
    
    # 创建文件
    touch $BLACKLIST
    
    # 添加到iptables
    iptables -I INPUT -s $ip -j DROP

    echo "Blocked $ip"
}

first(){
	
	apt update -y
	apt install  -y git tmux screen nano vim curl net-tools wget sudo proxychains iperf3 lsof conntrack openssl unzip lsb-release jq ca-certificates bash-completion iptables netcat-openbsd && update-ca-certificates
	bash <(curl -fsSL https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/tcping.sh)
	bash <(curl -fsSL https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/bashrc.sh)
	git clone https://github.com/iiiiiii1/doubi.git
	git clone https://github.com/hulisang/Port-forwarding.git
	git clone https://github.com/vpsxb/EasyRealM.git
	git clone https://github.com/seal0207/EasyRealM.git
	bash <(curl -fsSL https://raw.githubusercontent.com/P3TERX/script/master/speedtest-cli.sh)
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
	
	source <(curl -fsSL https://raw.githubusercontent.com/Jrohy/multi-v2ray/master/v2ray.sh) --zh

}

x-ui(){
	
	bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

}

x-ui-docker(){
	docker run -itd --network=host -v /root/x-ui/db/:/etc/x-ui/ -v /root/x-ui/cert/:/root/cert/ --name x-ui --restart=unless-stopped enwaiax/x-ui:latest
}

x_ui_install(){
	x-ui
}

v2ray-docker(){
	mkdir -p /root/v2ray
	wget -O /root/v2ray/config.json https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/config-v2ray.json
	docker run -d --network host --name v2ray --restart=always -v /root/v2ray:/etc/v2ray teddysun/v2ray
}

xray-docker(){
	
	mkdir -p /root/xray
	wget -O /root/xray/config.json https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/config-xray.json
	docker run -d --network host --name xray --restart=always -v /root/xray:/etc/xray teddysun/xray

}

hc(){
	bash <(curl -fsSL https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/jcnf.sh)
}

ihc(){
	bash <(curl -fsSL https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/ijcnf.sh)
}

tcpx(){
	bash <(curl -fsSL https://git.io/JYxKU)
}

ddxt(){
	bash <(curl -fsSL https://raw.githubusercontent.com/hiCasper/Shell/master/AutoReinstall.sh)
}

nfcheck(){
	bash <(curl -fsSL https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/check.sh)
}

yabs(){
	bash <(curl -fsSL yabs.sh)
}

lemonbench(){
	curl -fsSL raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/LemonBench.sh | bash -s fast
}

superbench(){
	bash <(curl -fsSL https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/superbench.sh)
}

speed(){
	curl -fsSL https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/superbench.sh | bash -s speed
}

io(){
	curl -fsSL https://raw.githubusercontent.com/jamespan2012/shbox/main/dependencies/superbench.sh | bash -s io
}

x_ipcheck(){
	echo -ne "3322: \t"
	curl -s http://ip.3322.net  # show ip

	echo "ip.p3terx.com:"
	curl ip.p3terx.com -4
	curl ip.p3terx.com -6
}

tzold(){
	bash <(curl -fsSL https://raw.githubusercontent.com/cokemine/ServerStatus-Hotaru/master/status.sh)
}

jg(){
	bash <(curl -fsSL raw.githubusercontent.com/Aurora-Admin-Panel/deploy/main/install.sh)
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
	bash <(curl -sSL raw.githubusercontent.com/wikihost-opensource/linux-toolkit/main/system-upgrade/debian.sh)	
}

x_pre_install(){
	echo "install... ufw/curl/socat/unzip" #mv /root/shbox.sh /usr/bin/bx
	apt update 
	apt install ufw 
	apt install curl -y
	apt install socat -y
	apt install unzip -y
}
x_hihy(){
	curl -fsSL -k -o /usr/bin/hihy https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/az/hihy.sh && chmod +x /usr/bin/hihy && hihy
}
x_aabt(){
	wget -q --no-check-certificate -O /usr/bin/aabt https://raw.githubusercontent.com/Lioncky/Lioncky/refs/heads/main/sh/az/aabt.sh && chmod +x /usr/bin/aabt && aabt
}
x_ovpn(){
	wget --no-check-certificate https://raw.githubusercontent.com/Nyr/openvpn-install/master/openvpn-install.sh -O /usr/bin/ovpn && chmod +x /usr/bin/ovpn && ovpn
}
x_iptest(){
	bash <(curl -Ls https://Check.Place) -I
}
x_docker(){
	curl -fsLS https://get.docker.com | bash
	echo | adduser $(id -un) docker
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
    if is_nums "$nums"; then 
		lsof -i:$nums
    fi
}

port_to(){
    read -p "输入要转发的本地端口: " nums
	if ! is_nums "$nums"; then
        return 1
    fi

    read -p "输入目标IP: " addr
    if ! [[ "$addr" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "❌ 请输入正确的 IPv4 地址"
        return 1
    fi

    read -p "输入目标端口: " targetnum
	if [[ -z "$targetnum" ]]; then
		targetnum="$nums"
	elif ! is_nums "$targetnum"; then
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
x_ufw_off(){
	read -p "输入要关闭的端口: " targetnum
	if is_nums "$targetnum"; then
        ufw deny ${targetnum} # allow 
    fi
}
x_ufw_on(){
	read -p "输入要放行的端口: " targetnum
	if is_nums "$targetnum"; then
		ufw allow ${targetnum} # allow 
    fi
}
x_iptable_init(){
	sysctl -w net.ipv4.ip_forward=1
	iptables -t nat -A POSTROUTING -j MASQUERADE
	echo "清理所有规则: \niptables -t nat -F\niptables -F"
	echo "删除第 1 个规则\niptables -t nat -D PREROUTING 1"
	echo "✅ IPTable-初始化完成"
	echo "> iptables -t nat -L PREROUTING -n --line-numbers"
	iptables -t nat -L PREROUTING -n --line-numbers
}
x_iptable_del(){
	iptables -t nat -L PREROUTING -n --line-numbers
	read -p "输入要删除的序号: " nums
	if ! is_nums "$nums"; then
        return 1
    fi
	iptables -t nat -D PREROUTING $nums
	echo "✅ 操作完成"
}
x_iptable_forward(){
    read -p "输入要转发的本地端口: " nums
	if ! is_nums "$nums"; then
        return 1
    fi

    read -p "输入目标IP: " addr
    if ! [[ "$addr" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "❌ 请输入正确的 IPv4 地址"
        return 1
    fi

    read -p "输入目标端口: " targetnum
	if [[ -z "$targetnum" ]]; then
		targetnum="$nums"
	elif ! is_nums "$targetnum"; then
		return 1
	fi

    # 开放本地端口
    ufw allow ${nums}/tcp

    echo "🔀 IPTable-转发规则: 本地 ${nums} → ${addr}:${targetnum}"
	iptables -t nat -A PREROUTING -p tcp --dport ${nums} -j DNAT --to-destination ${addr}:${targetnum}
	sudo iptables -A FORWARD -p tcp --dport ${nums} -j ACCEPT
	sudo iptables -A FORWARD -p tcp --sport ${nums} -j ACCEPT
    echo "✅ iptables add(PID=$!)"
}

x_allow_pubkey(){
	sed -i -E 's/^[#[:space:]]*(PubkeyAuthentication)[[:space:]]+(no|yes)$/\1 yes/' /etc/ssh/sshd_config
	systemctl restart sshd
}
x_add_ssh(){
	echo -e "正在检查... cat /etc/ssh/sshd_config | grep Pubkey PermitRootLogin UsePAM"
	conf="$(cat /etc/ssh/sshd_config)"

	echo "--- Pubkey ---"
	echo "$conf" | grep Pubkey

	echo "--- PermitRootLogin prohibit-password ---"
	echo "$conf" | grep prohibit-password

	echo "--- UsePAM ---"
	echo "$conf" | grep UsePAM

	#cat /etc/ssh/sshd_config | tee >(grep Pubkey) >(grep prohibit-password) >(grep UsePAM) >/dev/null
	# cat /etc/ssh/sshd_config | grep PubkeyAuthentication
	# cat /etc/ssh/sshd_config | grep prohibit-password
	# cat /etc/ssh/sshd_config | grep UsePAM

	echo -e "\t nano /etc/ssh/sshd_config"
	echo -e "\t PermitRootLogin prohibit->without-password"

	read -p "输入要添加的ssh.pub: " ssh_pub
	if [[ -n "$ssh_pub" ]]; then
		mkdir -p ~/.ssh && [ -f ~/.ssh/authorized_keys ] || touch ~/.ssh/authorized_keys
		echo -e "\t PubkeyAuthentication no->yes"
		sed -i -E 's/^[#[:space:]]*(PubkeyAuthentication)[[:space:]]+(no|yes)$/\1 yes/' /etc/ssh/sshd_config
		echo -e "已添加~ 正在重启<=>sshd..."
		echo "$ssh_pub" >> ~/.ssh/authorized_keys
		systemctl restart sshd
	fi
	echo -e "\t systemctl restart sshd"
}
x_xray_reality(){
	bash <(wget -qO- -o- https://github.com/233boy/Xray/raw/main/install.sh)
}
x_bbr(){
	bash <(wget -qO- https://cdn.cmqos.com/bbr.sh)
}
x_backtrace(){
	curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh
}

x_help(){
	echo -e "\033[96m\napt install"
	echo -e "端口占用: lsof -i:5090"
	echo -e "端口转发: apt apt install socat -y"
	echo -e "\tnohup socat TCP-LISTEN:3080,fork TCP:1.2.3.4:3306 > /dev/null 2>&1 &"
	echo -e "curl -x socks5://127.0.0.1:10808 https://ip.eoeg.cc/1.2.3.4"
	echo -e "\033[33m"
}
x_help_private(){
	echo -e "\tnohup socat TCP-LISTEN:6090,fork TCP:203.55.176.167:33306 > /dev/null 2>&1 &"
	echo -e "\tnohup /etc/hihy/bin/appS --log-level info -c /root/xia.json client >/dev/null 2>&1 &"
	echo -e "\tnohup /usr/local/x-ui/bin/xray-linux-amd64 -c /root/hy.json 2>&1 &"
}

check_root

echo -e "${Info}选择你要使用的功能: \033[95m \033[92m\t0.帮助 \t 00.自我更新\t 000.初始化~(curl/socat/ufw) ~"
echo -e "[功能]\n1.放行端口\t2.禁止端口\t3.查找进程\t 4.杀死进程\t5.端口查询.\t"
echo -e "6.端口转发\t7.IPTable\t8.IPT转发\t9.IPT删除\t10.拉黑IP\n"

echo -e "\033[34m[新的]\n11.XRAY-REALITY 22.线路优化bbr\t33.三网回城\t44.当前IP-3322\t"
echo -e "55.NodeQuality\t66.IP解锁查看\t77.IP解锁完整\t88.添加ssh公钥\t99.一键docker\n"

echo -e "\033[95m[安装]\n111.一键Hy\t 222.宝塔aapanel_zh\t 333.OpenVPN\t444.读写IO测试\t555Help提示\t"
echo -e "666.yabs测试\t 777.全网测速 \t 888.3XUI\t 999.3XUI(2.6.2) \n"

echo -e "\033[33m32.本地IP\t 33.老x-ui\t 35.极光面板\t 36.闲蛋面板\t 37.DD系统\t 38.建站环境\t 39.升级Debian(自动执行谨慎操作)"
echo -e "61.首次运行\t 62.安装docker\t 63.回程路由(ICMP)\t 64.魔法上网\t 65.回程路由(TCP)\t"
echo -e "68.superbench\t69.lemonbench\t 133.探针安装\t 166. BBR\t 29.流媒体测试 \t"
echo -e "\n\033[94m请选择:\033[0m"
read -p "" nums

	if	 [[ "${nums}" == "0" ]]; then x_help
	elif [[ "${nums}" == "00" ]]; then auto_update_bx
	elif [[ "${nums}" == "000" ]]; then x_pre_install 
	
	elif [[ "${nums}" == "1" ]]; then x_ufw_on
	elif [[ "${nums}" == "2" ]]; then x_ufw_off
	elif [[ "${nums}" == "3" ]]; then ps_ef
	elif [[ "${nums}" == "4" ]]; then proc_kill
	elif [[ "${nums}" == "5" ]]; then port_check
	elif [[ "${nums}" == "6" ]]; then port_to
	elif [[ "${nums}" == "7" ]]; then x_iptable_init
	elif [[ "${nums}" == "8" ]]; then x_iptable_forward #zf
	elif [[ "${nums}" == "9" ]]; then x_iptable_del
	elif [[ "${nums}" == "10" ]]; then x_block_ip
	
	elif [[ "${nums}" == "11" ]]; then x_xray_reality
	elif [[ "${nums}" == "22" ]]; then x_bbr 
	elif [[ "${nums}" == "33" ]]; then x_backtrace 
	elif [[ "${nums}" == "44" ]]; then x_ipcheck 
	elif [[ "${nums}" == "55" ]]; then bash <(curl -sL https://run.NodeQuality.com) 
	elif [[ "${nums}" == "66" ]]; then bash <(curl -Ls https://Check.Place) -I
	elif [[ "${nums}" == "77" ]]; then bash <(curl -Ls https://Check.Place)
	elif [[ "${nums}" == "88" ]]; then x_add_ssh
	elif [[ "${nums}" == "99" ]]; then x_docker


	elif [[ "${nums}" == "111" ]]; then x_hihy 
	elif [[ "${nums}" == "222" ]]; then x_aabt
	elif [[ "${nums}" == "333" ]]; then x_ovpn
	elif [[ "${nums}" == "444" ]]; then io
	elif [[ "${nums}" == "555" ]]; then x_help_private
	elif [[ "${nums}" == "666" ]]; then yabs
	elif [[ "${nums}" == "777" ]]; then speed
	elif [[ "${nums}" == "888" ]]; then bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
	elif [[ "${nums}" == "999" ]]; then bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) v2.6.2
 
	
	elif [[ "${nums}" == "23" ]]; then x_ipcheck
	elif [[ "${nums}" == "29" ]]; then nfcheck

	#首次安装
	elif [[ "${nums}" == "61" ]]; then first
	elif [[ "${nums}" == "62" ]]; then doc
	elif [[ "${nums}" == "63" ]]; then ihc
	elif [[ "${nums}" == "163" ]]; then tcpx # BBR
	elif [[ "${nums}" == "64" ]]; then proxy
	elif [[ "${nums}" == "65" ]]; then hc
	elif [[ "${nums}" == "68" ]]; then superbench
	elif [[ "${nums}" == "69" ]]; then LemonBench
	elif [[ "${nums}" == "133" ]]; then tzold

	
	elif [[ "${nums}" == "32" ]]; then x_ipcheck
	elif [[ "${nums}" == "34" ]]; then x_ui_install
	elif [[ "${nums}" == "35" ]]; then jg
	elif [[ "${nums}" == "36" ]]; then xd
	elif [[ "${nums}" == "37" ]]; then ddxt
	elif [[ "${nums}" == "38" ]]; then lnmps
	elif [[ "${nums}" == "39" ]]; then update_debian
		
	else
		echo -e "${Info} 输入无效" && read -p "输入数字选择:" nums
	fi
