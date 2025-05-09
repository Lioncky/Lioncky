#coding: utf-8
# +-------------------------------------------------------------------
# | 宝塔Linux面板
# +-------------------------------------------------------------------
# | Copyright (c) 2015-2099 宝塔软件(http://bt.cn) All rights reserved.
# +-------------------------------------------------------------------
# | Author: hwliang <hwl@bt.cn>
# +-------------------------------------------------------------------

#------------------------------
# 工具箱/etc/resolv.conf
#------------------------------
import sys,os
panelPath = '/www/server/panel/'
os.chdir(panelPath)
sys.path.insert(0,panelPath + "class/")
import public,time,json
if sys.version_info[0] == 3: raw_input = input

#设置MySQL密码
def set_mysql_root(password):
    import db,os
    sql = db.Sql()
    
    root_mysql = '''#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
pwd=$1
/etc/init.d/mysqld stop
mysqld_safe --skip-grant-tables&
echo 'Changing password...';
sleep 6
m_version=$(cat /www/server/mysql/version.pl|grep -E "(5.1.|5.5.|5.6.|10.0|10.1)")
m2_version=$(cat /www/server/mysql/version.pl|grep -E "(10.5.|10.4.)")
if [ "$m_version" != "" ];then
    mysql -uroot -e "UPDATE mysql.user SET password=PASSWORD('${pwd}') WHERE user='root'";
elif [ "$m2_version" != "" ];then
    mysql -uroot -e "FLUSH PRIVILEGES;alter user 'root'@'localhost' identified by '${pwd}';alter user 'root'@'127.0.0.1' identified by '${pwd}';FLUSH PRIVILEGES;";
else
    m_version=$(cat /www/server/mysql/version.pl|grep -E "(5.7.|8.0.)")
    if [ "$m_version" != "" ];then
        mysql -uroot -e "FLUSH PRIVILEGES;update mysql.user set authentication_string='' where user='root' and (host='127.0.0.1' or host='localhost');alter user 'root'@'localhost' identified by '${pwd}';alter user 'root'@'127.0.0.1' identified by '${pwd}';FLUSH PRIVILEGES;";
    else
        mysql -uroot -e "update mysql.user set authentication_string=password('${pwd}') where user='root';"
    fi
fi
mysql -uroot -e "FLUSH PRIVILEGES";
pkill -9 mysqld_safe
pkill -9 mysqld
pkill -9 mysql
sleep 2
/etc/init.d/mysqld start

echo '==========================================='
echo "The root password set ${pwd}  successuful"''';
    
    public.writeFile('mysql_root.sh',root_mysql)
    os.system("/bin/bash mysql_root.sh " + password)
    os.system("rm -f mysql_root.sh")
    
    result = sql.table('config').where('id=?',(1,)).setField('mysql_root',password)
    print(result)

#设置面板密码
def set_panel_pwd(password,ncli = False):
    import db
    sql = db.Sql()
    result = sql.table('users').where('id=?',(1,)).setField('password',public.password_salt(public.md5(password),uid=1))
    username = sql.table('users').where('id=?',(1,)).getField('username')
    if ncli:
        print("|-%s: " % public.GetMsg("USER_NAME") + username)
        print("|-%s: " % public.GetMsg("NEW_PASS") + password)
    else:
        print(username)

#设置数据库目录
def set_mysql_dir(path):
    mysql_dir = r'''#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
oldDir=`cat /etc/my.cnf |grep 'datadir'|awk '{print $3}'`
newDir=$1
mkdir $newDir
if [ ! -d "${newDir}" ];then
    echo 'The specified storage path does not exist!'
    exit
fi
echo "Stopping MySQL service..."
/etc/init.d/mysqld stop

echo "Copying files, please wait..."
\cp -r -a $oldDir/* $newDir
chown -R mysql.mysql $newDir
sed -i "s#$oldDir#$newDir#" /etc/my.cnf

echo "Starting MySQL service..."
/etc/init.d/mysqld start
echo ''
echo 'Successful'
echo '---------------------------------------------------------------------'
echo "Has changed the MySQL storage directory to: $newDir"
echo '---------------------------------------------------------------------'
'''

    public.writeFile('mysql_dir.sh',mysql_dir)
    os.system("/bin/bash mysql_dir.sh " + path)
    os.system("rm -f mysql_dir.sh")


#封装
def PackagePanel():
    print('========================================================')
    print('|-'+public.GetMsg("CLEARING_LOG")+'...'),
    public.M('logs').where('id!=?',(0,)).delete()
    print('\t\t\033[1;32m[done]\033[0m')
    print('|-'+public.GetMsg("CLEARING_TASK_HISTORY")+'...'),
    public.M('tasks').where('id!=?',(0,)).delete()
    print('\t\t\033[1;32m[done]\033[0m')
    print('|-'+public.GetMsg("CLEARING_NET_MO")+'...'),
    public.M('network').dbfile('system').where('id!=?',(0,)).delete()
    print('\t\033[1;32m[done]\033[0m')
    print('|-'+public.GetMsg("CLEARING_CPU_MO")+'...'),
    public.M('cpuio').dbfile('system').where('id!=?',(0,)).delete()
    print('\t\033[1;32m[done]\033[0m')
    print('|-'+public.GetMsg("CLEARING_DISK_MO")+'...'),
    public.M('diskio').dbfile('system').where('id!=?',(0,)).delete()
    print('\t\033[1;32m[done]\033[0m')
    print('|-'+public.GetMsg("CLEARING_IP")+'...'),
    os.system('rm -f /www/server/panel/data/iplist.txt')
    os.system('rm -f /www/server/panel/data/address.pl')
    os.system('rm -f /www/server/panel/data/*.login')
    os.system('rm -f /www/server/panel/data/domain.conf')
    os.system('rm -f /www/server/panel/data/user*')
    os.system('rm -f /www/server/panel/data/admin_path.pl')
    os.system('rm -f /root/.ssh/*')

    print('\t\033[1;32m[done]\033[0m')
    print('|-'+public.GetMsg("CLEARING_SYS_HISTORY")+'...'),
    command = '''cat /dev/null > /var/log/boot.log
cat /dev/null > /var/log/btmp
cat /dev/null > /var/log/cron
cat /dev/null > /var/log/dmesg
cat /dev/null > /var/log/firewalld
cat /dev/null > /var/log/grubby
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/mail.info
cat /dev/null > /var/log/maillog
cat /dev/null > /var/log/messages
cat /dev/null > /var/log/secure
cat /dev/null > /var/log/spooler
cat /dev/null > /var/log/syslog
cat /dev/null > /var/log/tallylog
cat /dev/null > /var/log/wpa_supplicant.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/yum.log
history -c
'''
    os.system(command)
    print('\t\033[1;32m[done]\033[0m')


    print("|-Please select user initialization method:")
    print("="*50)
    print(" (1) Display the initialization page when accessing the panel page")
    print(" (2) A new account password is automatically generated randomly when first started")
    print("="*50)
    p_input = input("Please select the initialization method (default: 1):")
    print(p_input)
    if p_input in [2,'2']:
        public.writeFile('/www/server/panel/aliyun.pl',"True")
        s_file = '/www/server/panel/install.pl'
        if os.path.exists(s_file): os.remove(s_file)
        public.M('config').where("id=?",('1',)).setField('status',1)
    else:
        public.writeFile('/www/server/panel/install.pl',"True")
        public.M('config').where("id=?",('1',)).setField('status',0)
    port = public.readFile('data/port.pl').strip()
    print('========================================================')
    print('\033[1;32m|-The panel packaging is successful, please do not log in to the panel to do any other operations!\033[0m')
    if not p_input in [2,'2']:
        print('\033[1;41m|-Panel initialization address:http://{SERVERIP}:'+port+'/install\033[0m')
    else:
        print('\033[1;41m|-Get the initial account password command:bt default \033[0m')

#清空正在执行的任务
def CloseTask():
    ncount = public.M('tasks').where('status!=?',(1,)).delete()
    os.system("kill `ps -ef |grep 'python panelSafe.pyc'|grep -v grep|grep -v panelExec|awk '{print $2}'`")
    os.system("kill `ps -ef |grep 'install_soft.sh'|grep -v grep|grep -v panelExec|awk '{print $2}'`")
    os.system('/etc/init.d/bt restart')
    print(public.GetMsg("CLEAR_TASK",(int(ncount),)))
    
#自签证书
def CreateSSL():
    import OpenSSL
    key = OpenSSL.crypto.PKey()
    key.generate_key( OpenSSL.crypto.TYPE_RSA, 2048 )
    cert = OpenSSL.crypto.X509()
    cert.set_serial_number(0)
    cert.get_subject().CN = public.GetLocalIp()
    cert.set_issuer(cert.get_subject())
    cert.gmtime_adj_notBefore( 0 )
    cert.gmtime_adj_notAfter( 10*365*24*60*60 )
    cert.set_pubkey( key )
    cert.sign( key, 'md5' )
    cert_ca = OpenSSL.crypto.dump_certificate(OpenSSL.crypto.FILETYPE_PEM, cert)
    private_key = OpenSSL.crypto.dump_privatekey(OpenSSL.crypto.FILETYPE_PEM, key)
    if isinstance(cert_ca,bytes):
        cert_ca = bytes.decode(cert_ca)
        private_key = bytes.decode(private_key)
    if len(cert_ca) > 100 and len(private_key) > 100:
        public.writeFile('ssl/certificate.pem',cert_ca)
        public.writeFile('ssl/privateKey.pem',private_key)
        public.writeFile('/www/server/panel/data/ssl.pl','')
        print('success')
        return
    print('error')

#创建文件
def CreateFiles(path,num):
    if not os.path.exists(path): os.system('mkdir -p ' + path)
    import time
    for i in range(num):
        filename = path + '/' + str(time.time()) + '__' + str(i)
        open(path,'w+').close()

#计算文件数量
def GetFilesCount(path):
    i=0
    for name in os.listdir(path): i += 1
    return i


#清理系统垃圾
def ClearSystem():
    count = total = 0
    tmp_total,tmp_count = ClearMail()
    count += tmp_count
    total += tmp_total
    print('=======================================================================')
    tmp_total,tmp_count = ClearSession()
    count += tmp_count
    total += tmp_total
    print('=======================================================================')
    tmp_total,tmp_count = ClearOther()
    count += tmp_count
    total += tmp_total
    print('=======================================================================')
    print('\033[1;32m|-'+public.GetMsg("CLEAR_RUBBISH",(str(count),ToSize(total)))+'\033[0m')

#清理邮件日志
def ClearMail():
    rpath = '/var/spool'
    total = count = 0
    import shutil
    con = ['cron','anacron','mail']
    for d in os.listdir(rpath):
        if d in con: continue
        dpath = rpath + '/' + d
        print('|-Cleaning up' + dpath + ' ...')
        time.sleep(0.2)
        num = size = 0
        for n in os.listdir(dpath):
            filename = dpath + '/' + n
            fsize = os.path.getsize(filename)
            print('|---['+ToSize(fsize)+'] del ' + filename),
            size += fsize
            if os.path.isdir(filename):
                shutil.rmtree(filename)
            else:
                os.remove(filename)
            print('\t\033[1;32m[OK]\033[0m')
            num += 1
        print(public.GetMsg("CLEAR_RUBBISH1",(dpath,str(num),ToSize(size))))
        total += size;
        count += num;
    print('=======================================================================')
    print(public.GetMsg('CLEAR_RUBBISH2',(str(count),ToSize(total))))
    return total,count

#清理php_session文件
def ClearSession():
    spath = '/tmp'
    total = count = 0
    import shutil
    print(public.GetMsg("CLEAR_PHP_SESSION"))
    for d in os.listdir(spath):
        if d.find('sess_') == -1: continue
        filename = spath + '/' + d
        fsize = os.path.getsize(filename)
        print('|---['+ToSize(fsize)+'] del ' + filename),
        total += fsize
        if os.path.isdir(filename):
            shutil.rmtree(filename)
        else:
            os.remove(filename)
        print('\t\033[1;32m[OK]\033[0m')
        count += 1;
    print(public.GetMsg("CLEAR_PHP_SESSION1",(str(count),ToSize(total))))
    return total,count

#清空回收站
def ClearRecycle_Bin():
    import files
    f = files.files();
    f.Close_Recycle_bin(None);
    
#清理其它
def ClearOther():
    clearPath = [
                 {'path':'/www/server/panel','find':'testDisk_'},
                 {'path':'/www/wwwlogs','find':'log'},
                 {'path':'/tmp','find':'panelBoot.pl'},
                 {'path':'/www/server/panel/install','find':'.rpm'},
                 {'path':'/www/server/panel/install','find':'.zip'},
                 {'path':'/www/server/panel/install','find':'.gz'}
                 ]
    
    total = count = 0
    print(public.GetMsg("CLEAR_RUBBISH3"))
    for c in clearPath:
        for d in os.listdir(c['path']):
            if d.find(c['find']) == -1: continue
            filename = c['path'] + '/' + d
            if os.path.isdir(filename): continue
            fsize = os.path.getsize(filename)
            print('|---['+ToSize(fsize)+'] del ' + filename),
            total += fsize
            os.remove(filename)
            print('\t\033[1;32m[OK]\033[0m')
            count += 1
    public.serviceReload()
    os.system('sleep 1 && /etc/init.d/bt reload > /dev/null &')
    print(public.GetMsg("CLEAR_RUBBISH4",(str(count),ToSize(total))))
    return total,count

#关闭普通日志
def CloseLogs():
    try:
        paths = ['/usr/lib/python2.7/site-packages/web/httpserver.py','/usr/lib/python2.6/site-packages/web/httpserver.py']
        for path in paths:
            if not os.path.exists(path): continue
            hsc = public.readFile(path)
            if hsc.find('500 Internal Server Error') != -1: continue
            rstr = '''def log(self, status, environ):
        if status != '500 Internal Server Error': return;'''
            hsc = hsc.replace("def log(self, status, environ):",rstr)
            if hsc.find('500 Internal Server Error') == -1: return False
            public.writeFile(path,hsc)
    except:pass

#字节单位转换
def ToSize(size):
    ds = ['b','KB','MB','GB','TB']
    for d in ds:
        if size < 1024: return str(size)+d
        size = size / 1024
    return '0b'

#随机面板用户名
def set_panel_username(username = None):
    import db
    sql = db.Sql()
    if username:
        if len(username) < 3:
            print(public.GetMsg("USER_NAME_LEN_ERR"))
            return;
        if username in ['admin','root']:
            print(public.GetMsg("EASY_NAME"))
            return;

        sql.table('users').where('id=?',(1,)).setField('username',username)
        print(public.GetMsg("NEW_NAME",(username,)))
        return;
    
    username = sql.table('users').where('id=?',(1,)).getField('username')
    if username == 'admin': 
        username = public.GetRandomString(8).lower()
        sql.table('users').where('id=?',(1,)).setField('username',username)
    print('username: ' + username)
    
#设定idc
def setup_idc():
    try:
        panelPath = '/www/server/panel'
        filename = panelPath + '/data/o.pl'
        if not os.path.exists(filename): return False
        o = public.readFile(filename).strip()
        c_url = 'http://www.bt.cn/api/idc/get_idc_info_bycode?o=%s' % o
        idcInfo = json.loads(public.httpGet(c_url))
        if not idcInfo['status']: return False
        pFile = panelPath + '/config/config.json'
        pInfo = json.loads(public.readFile(pFile))
        pInfo['brand'] = idcInfo['msg']['name']
        pInfo['product'] = public.GetMsg("WITH_BT_CUSTOM_EDITION")
        public.writeFile(pFile,json.dumps(pInfo))
        tFile = panelPath + '/data/title.pl'
        titleNew = (pInfo['brand'] + public.GetMsg("PANEL")).encode('utf-8')
        if os.path.exists(tFile):
            title = public.GetConfigValue('title')
            if title == '宝塔Linux面板' or title == '': 
                public.writeFile(tFile,titleNew)
                public.SetConfigValue('title',titleNew)
        else:
            public.writeFile(tFile,titleNew)
            public.SetConfigValue('title',titleNew)
        return True
    except:pass

#将插件升级到6.0
def update_to6():
    print("====================================================")
    print(public.GetMsg("PLUG_UPDATEING"))
    print("====================================================")
    download_address = public.get_url()
    exlodes = ['gitlab','pm2','mongodb','deployment_jd','logs','docker','beta','btyw']
    for pname in os.listdir('plugin/'):
        if not os.path.isdir('plugin/' + pname): continue
        if pname in exlodes: continue
        print("|-upgrading【%s】..." % pname),
        download_url = download_address + '/install/plugin/' + pname + '/install.sh'
        to_file = '/tmp/%s.sh' % pname
        public.downloadFile(download_url,to_file)
        os.system('/bin/bash ' + to_file + ' install &> /tmp/plugin_update.log 2>&1')
        print("    \033[32m[success]\033[0m")
    print("====================================================")
    print("\033[32m"+public.GetMsg("PLUG_UPDATE_TO_6")+"\033[0m")
    print("====================================================")

#命令行菜单
def bt_cli(u_input = 0):
    raw_tip = "==============================================="
    if not u_input:
        print(''' 
        =============== BT-aapanel ==================
        (01) 重启面板                    (08) 更改面板端口
        (02) 停止面板                    (09) 清除面板缓存
        (03) 启动面板                    (10) 清除登录限制
        (04) 重新加载面板                (11) 取消入口限制
        (05) 更改面板密码                (12) 取消域名绑定限制
        (06) 更改面板用户名              (13) 取消 IP 访问限制
        (07) 强制更改 MySQL root 密码    (14) 查看面板默认信息
        (22) 显示面板错误日志            (15) 修复面板(检查错误并将面板文件更新到最新版本)
        (24) 关闭谷歌身份验证器          (17) 设置日志切割打开/关闭压缩
        (25) 设置是否自动备份面板        (18) 设置是否保存文件的历史副本
        (26) 备份到云存储时保留/删除本地备份
        
        (0)取消
        ''')
        if False:
            print("==============="+public.GetMsg("PANEL_SHELL")+"==================")
            print("(1) %s                           (8) %s" % (public.GetMsg("RESTART_PANEL"),public.GetMsg("CHANGE_PANEL_PORT")))
            print("(2) %s                              (9) %s"% (public.GetMsg("STOP_PANEL"),public.GetMsg("CLEAR_PANEL_CACHE")))
            print("(3) %s                             (10) %s"% (public.GetMsg("START_PANEL"),public.GetMsg("CLEAR_PANEL_LIMIT")))
            print("(4) %s                            (11) %s"% (public.GetMsg("RELOAD_PANEL"),public.GetMsg("CANCEL_ENTRY")))
            print("(5) %s                   (12) %s"% (public.GetMsg("CHANGE_PANEL_PASS"),public.GetMsg("CANCEL_DOMAIN_BIND")))
            print("(6) %s                   (13) %s"% (public.GetMsg("CHANGE_PANEL_USER"),public.GetMsg("CANCEL_IP_LIMIT")))
            print("(7) %s     (14) %s"% (public.GetMsg("CHANGE_MYSQL_PASS_FORCE"),public.GetMsg("GET_PANEL_DEFAULT_MSG")))
            print("(22) %s                (15) %s"% ("Display panel error log",public.GetMsg("CLEAR_SYS_RUBBISH")))
            print("(23) %s      (16) %s"% ("Turn off BasicAuth authentication","Repair panel (check for errors and update panel files to the latest version)"))
            print("(24) Turn off Google Authenticator          (17) Set log cutting on/off compression")
            print("(25) Set whether to back up the panel automatically  (18) Set whether to save a historical copy of the file")
            print("(26) Keep/Remove local backup when backing up to cloud storage")
            print("(0) Cancel")
            print(raw_tip)
        try:
            u_input = input("请输入指令:") #input(public.GetMsg("INPUT_CMD_NUM"))
            if sys.version_info[0] == 3: u_input = int(u_input)
        except: u_input = 0
    try:
        if u_input in ['log','logs','error','err','tail','debug','info']:
            os.system("tail -f {}".format(public.get_panel_log_file()))
            return
        if u_input[:6] in ['install','update']:
            print("Tip: Example of command parameter transfer (compile and install php7.4):bt install/0/php/7.4")
            print(sys.argv)
            install_args = u_input.split('/')
            if len(install_args) < 2:
                try:
                    install_input = input("Please select the installation method (0 compile install, 1 speed install, default: 1):")
                    install_input = int(install_input)
                except:
                    install_input = 1
            else:
                install_input = int(install_args[1])
            print(raw_tip)
            soft_list = 'nginx apache php mysql memcached redis pure-ftpd phpmyadmin pm2 docker openlitespeed mongodb'
            soft_list_arr = soft_list.split(' ')
            if len(install_args) < 3:
                install_soft = ''
                while not install_soft:
                    print("Supported software:{}".format(soft_list))
                    print(raw_tip)
                    install_soft = input("Please enter the name of the software to be installed (eg: nginx)：")
                    if install_soft not in soft_list_arr:
                        print("Software that does not support command line installation")
                        install_soft = ''
            else:
                install_soft = install_args[2]

            print(raw_tip)
            if len(install_args) < 4:
                install_version = ''
                while not install_version:
                    print(raw_tip)
                    install_version = input("Please enter the version number to be installed (for example: 1.18):")
            else:
                install_version = install_args[3]

            print(raw_tip)
            os.system("bash /www/server/panel/install/install_soft.sh {} {} {} {}".format(install_input,install_args[0],install_soft,install_version))
            exit()

        print("Unsupported command")
        exit()
    except: pass

    nums = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26]
    if not u_input in nums:
        print(raw_tip)
        print(public.GetMsg("CANCELLED"))
        exit()

    print(raw_tip)
    print(public.GetMsg("EXECUTING",(u_input,)))
    print(raw_tip)

    if u_input == 1:
        os.system("/etc/init.d/bt restart")
    elif u_input == 2:
        os.system("/etc/init.d/bt stop")
    elif u_input == 3:
        os.system("/etc/init.d/bt start")
    elif u_input == 4:
        os.system("/etc/init.d/bt reload")
    elif u_input == 5:
        if sys.version_info[0] == 2:
            input_pwd = raw_input(public.GetMsg("INPUT_NEW_PASS"))
        else:
            input_pwd = input(public.GetMsg("INPUT_NEW_PASS"))
        set_panel_pwd(input_pwd.strip(),True)
    elif u_input == 6:
        if sys.version_info[0] == 2:
            input_user = raw_input(public.GetMsg("INPUT_NEW_USER"))
        else:
            input_user = input(public.GetMsg("INPUT_NEW_USER"))
        set_panel_username(input_user.strip())
    elif u_input == 7:
        if sys.version_info[0] == 2:
            input_mysql = raw_input(public.GetMsg("INPUT_NEW_MYSQL_PASS"))
        else:
            input_mysql = input(public.GetMsg("INPUT_NEW_MYSQL_PASS"))
        if not input_mysql:
            print(public.GetMsg("PASS_NOT_EMPTY"))
            return;

        if len(input_mysql) < 8:
            print(public.GetMsg("PASS_LEN_ERR"))
            return;

        import re
        rep = r"^[\w@\._]+$"
        if not re.match(rep, input_mysql):
            print(public.GetMsg("PASS_SPECIAL_CHARACTRES_ERR"))
            return;
        
        print(input_mysql)
        set_mysql_root(input_mysql.strip())
    elif u_input == 8:
        input_port = input(public.GetMsg("INPUT_NEW_PANEL_PORT"))
        if sys.version_info[0] == 3: input_port = int(input_port)
        if not input_port:
            print(public.GetMsg("INPUT_PANEL_PORT_ERR"))
            return;
        if input_port in [80,443,21,20,22]:
            print(public.GetMsg("CANT_USE_USUALLY_PORT_ERR"))
            return;
        old_port = int(public.readFile('data/port.pl'))
        if old_port == input_port:
            print(public.GetMsg("NEW_PORT_SAMEAS_OLD"))
            return;

        is_exists = public.ExecShell("lsof -i:%s|grep LISTEN|grep -v grep" % input_port)
        if len(is_exists[0]) > 5:
            print(public.GetMsg("PORT_ALREADY_IN_USE"))
            return;

        public.writeFile('data/port.pl',str(input_port))
        if os.path.exists("/usr/bin/firewall-cmd"):
            os.system("firewall-cmd --permanent --zone=public --add-port=%s/tcp" % input_port)
            os.system("firewall-cmd --reload")
        elif os.path.exists("/etc/sysconfig/iptables"):
            os.system("iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport %s -j ACCEPT" % input_port)
            os.system("service iptables save")
        else:
            os.system("ufw allow %s" % input_port)
            os.system("ufw reload")
        os.system("/etc/init.d/bt reload")
        print(public.GetMsg("CHANGE_PORT_SUCCESS",(input_port,)))
        print(public.GetMsg("CLOUD_RELEASE_PORT",(input_port,)))
    elif u_input == 9:
        sess_file = '/www/server/panel/data/session'
        if os.path.exists(sess_file):
            os.system("rm -f {}/*".format(sess_file))
        os.system("/etc/init.d/bt reload")
    elif u_input == 10:
        os.system("/etc/init.d/bt reload")
    elif u_input == 11:
        auth_file = 'data/admin_path.pl'
        if os.path.exists(auth_file): os.remove(auth_file)
        os.system("/etc/init.d/bt reload")
        print(public.GetMsg("CHANGE_LIMITED_CANCEL"))
    elif u_input == 12:
        auth_file = 'data/domain.conf'
        if os.path.exists(auth_file): os.remove(auth_file)
        os.system("/etc/init.d/bt reload")
        print(public.GetMsg("CHANGE_DOMAIN_CANCEL"))
    elif u_input == 13:
        auth_file = 'data/limitip.conf'
        if os.path.exists(auth_file): os.remove(auth_file)
        os.system("/etc/init.d/bt reload")
        print(public.GetMsg("CHANGE_IP_CANCEL"))
    elif u_input == 14:
        os.system("/etc/init.d/bt default")
    elif u_input == 15:
        ClearSystem()
    elif u_input == 16:
        os.system("/www/server/panel/pyenv/bin/pip install cachelib")
        os.system("curl https://node.aapanel.com/install/update6_en.sh|bash")
    elif u_input == 17:
        l_path = '/www/server/panel/data/log_not_gzip.pl'
        if os.path.exists(l_path):
            print("|-Detected that gzip compression is turned off and is being turned on...")
            os.remove(l_path)
            print("|-Gzip compression is turned on")
        else:
            print("|-Detected that gzip compression is turned on, closing ...")
            public.writeFile(l_path,'True')
            print("|-Gzip compression turned off")
    elif u_input == 18:
        l_path = '/www/server/panel/data/not_auto_backup.pl'
        if os.path.exists(l_path):
            print("|-Detected that the panel auto backup function is turned off and is being turned on...")
            os.remove(l_path)
            print("|-Panel auto backup function is turned on")
        else:
            print("|-Detected that the panel automatic backup function is turned on and is closing...")
            public.writeFile(l_path,'True')
            print("|-Panel auto-backup function turned off")
    elif u_input == 22:
        os.system('tail -100 /www/server/panel/logs/error.log')
    elif u_input == 23:
        filename = '/www/server/panel/config/basic_auth.json'
        if os.path.exists(filename): os.remove(filename)
        os.system('bt reload')
        print("|-BasicAuth authentication has been turned off")
    elif u_input == 24:
        filename = '/www/server/panel/data/two_step_auth.txt'
        if os.path.exists(filename): os.remove(filename)
        print("|-Google authentication turned off")
    elif u_input == 25:
        l_path = '/www/server/panel/data/not_file_history.pl'
        if os.path.exists(l_path):
            print("|-Detected that the file copy function is turned off and is being turned on...")
            os.remove(l_path)
            print("|-Document copy function turned on")
        else:
            print("|-Detected that the file copy function is turned on and is closing...")
            public.writeFile(l_path,'True')
            print("|-File copy function turned off")
    elif u_input == 26:
        keep_local = "/www/server/panel/data/is_save_local_backup.pl"
        if os.path.exists(keep_local):
            print("|-The local file retention setting is turned off")
            os.remove(keep_local)
        else:
            print("|-The local file retention setting is turned on")
            os.mknod(keep_local)



if __name__ == "__main__":
    type = sys.argv[1]
    if type == 'root':
        set_mysql_root(sys.argv[2])
    elif type == 'panel':
        set_panel_pwd(sys.argv[2])
    elif type == 'username':
        set_panel_username()
    elif type == 'o':
        setup_idc()
    elif type == 'mysql_dir':
        set_mysql_dir(sys.argv[2])
    elif type == 'package':
        PackagePanel()
    elif type == 'ssl':
        CreateSSL()
    elif type == 'clear':
        ClearSystem()
    elif type == 'closelog':
        CloseLogs()
    elif type == 'update_to6':
        update_to6()
    elif type == "cli":
        clinum = 0
        try:
            if len(sys.argv) > 2:
                clinum = int(sys.argv[2]) if sys.argv[2][:6] not in ['instal','update'] else sys.argv[2]
        except:
            clinum = sys.argv[2]
        bt_cli(clinum)
    else:
        print('ERROR: Parameter error')
