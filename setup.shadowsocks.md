安装配置shadowsocks
====================

shadowsocks是最近比较热门的翻墙方法，资源占用小，翻墙速度快，配置简单，开源项目有多个版本可以应用。只要在搭建一个服务器端，并建立一个客户端就可以翻墙使用了。

### 搭建服务器端

#### 安装

shadowsocks有多个版本可用。它的最初开发者是clowwindy用python开发的。就安装Python版。现在Python安装比较方便了，只要安装pip工具，就可以直接下载安装Python程序。

Centos下可以用：

	yum install m2crypto python-setuptools
	easy_install pip
	pip install shadowsocks

Ubuntu下可以用：
	
	apt-get install python-pip python-m2crypto
	pip install shadowsocks

#### 服务器端配置

安装完成后，创建一个配置文件`/etc/shadowsocks.json`，添加如下内容：

	{
    	"server":"0.0.0.0",  			//服务端监听的地址，服务端可填写 0.0.0.0
    	"server_port":8388,				//服务端的端口
    	"local_address": "127.0.0.1",	//本地端监听的地址
    	"local_port":1080,				//本地端的端口
    	"password":"xxxxxx",			//用于加密的密码
    	"timeout":300,					//超时时间，单位秒
    	"method":"aes-256-cfb",			//默认 "aes-256-cfb"
    	"fast_open": false,				//是否使用 TCP_FASTOPEN, true / false
    	"workers": 1					//worker 数量，Unix/Linux 可用，如果不理解含义请不要改
	}

在服务器上运行`ssserver -c /etc/shadowsocks.json` 即可。但这个时候shadowsocks在前台运行，在终端会不停的显示信息。此外，shadowsocks有时不太稳定，会自动的退出。shadowsocks官方推荐应用supervisor来监管shadowsocks的运行。



### shadowsocks客户端的安装和配置

#### windows客户端

windows下有shadowsocks-gui客户端，下载后图形界面，配置很容易。
下载地址：`http://sourceforge.net/projects/shadowsocksgui/`

#### 安装shadowsocks的openwrt的客户端

我的是hg255D路由器刷的Pandorabox12.04，shadowsocks没有支持该路由的版本，参考shuzy.com网站的教程，手动安装成功。

Shadowsocks官方没有为RT3052平台的路由器编译安装包，需要自己下载源代码编译。比较令人绝望的是针对HG255D编译的Shadowsocks竟然也不能在OpenWrt上直接安装，会提示平台不兼容。既然不能自动安装，那就只好手动安装了。

#### 手动安装原理

OpenWrt的ipk安装包其实是一个压缩文件，将其逐层解压两次之后可以看到有三个文件：

	control.tar.gz 安装包描述
	data.tar.gz 可执行文件和配置文件
	debian-binary 版本信息

自动安装ipk安装包时，系统将`data.tar.gz`的可执行文件和配置文件解压到指定目录，然后对`control.tar.gz`的信息进行记录，这样就可以在软件包列表里看到这个软件了

我们说的手动安装其实就是代替系统将`data.tar.gz`里的可执行文件和配置文件解压到指定目录，这样也可以正常运行。但是由于系统没有记录我们的安装信息，所以手动安装的软件在系统的软件列表里是看不到的，卸载也需要手动卸载。

#### 开始安装

这里以编译的Shadowsocks 1.4.5为例，这个版本用的是openssl库。

首先SSH登录到路由器，依次执行以下命令：

		cd /tmp

下载Shadowsocks的data.tar.gz压缩包

		wget http://uploads.shuyz.com/openwrt/hg255d/shadowsocks-libev_1.4.5_ramips_24kec%20dfd/data.tar.gz

安装(解压文件到指定目录)

	gunzip data.tar.gz
	tar xvf data.tar -C /

删除临时文件
	
	rm data.tar

至此安装完成，输入`ss-local`命令看是否有输出，如果看到帮助信息说明安装成功

Shadowsocks安装后会有三个文件：

	ss-local socks5 协议代理
	ss-redir 透明代理
	ss-tunnel 端口转发

#### 卸载Shadowsocks

如果需要卸载，删除安装过程添加的文件就可以卸载了，依次输入以下命令：

如果启用了服务需要先禁用

	/etc/init.d/shadowsocks disable

删除文件
	
	rm /etc/init.d/shadowsocks
	rm /etc/shadowsocks.json
	rm /usr/bin/ss-local
	rm /usr/bin/ss-redir
	rm /usr/bin/ss-tunnel

#### 配置Shadowsocks

输入命令`vi /etc/shadowsocks.json`编辑shadowsocks配置文件。不要忘记method配置项里加密方式要加引号，否则会提示ERROR: 7:14: Unexpected a when seeking value错误

#### 测试Shadowsocks

输入下面的命令启动shadowsocks客户端：

	ss-local -c /etc/shadowsocks.json

shadowsocks.json的配置文件和服务器差不多只是要把server换成你的服务器地址：

	{
    	"server":"x.x.x.x",  	//服务端监听的地址，服务端可填写 0.0.0.0
    	"server_port":8388,				//服务端的端口
    	"local_address": "127.0.0.1",	//本地端监听的地址
    	"local_port":1080,				//本地端的端口
    	"password":"xxxxxxx",			//用于加密的密码
    	"timeout":300,					//超时时间，单位秒
    	"method":"aes-256-cfb",			//默认 "aes-256-cfb"
	}