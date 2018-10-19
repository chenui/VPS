n2n突破内网互联安装
===================

### **概述**

如果要实现设备的远程访问，比如在公司访问家里的电脑、路由器、智能开关等，我们一般会需要一个公网地址，然后将相应端口映射到指定设备上。随着IPV4地址的枯竭，有些ISP已经不提供公网IP了，而且即使有公网IP，我们不一定有权限操作NAT路由的端口映射(比如公司的网络)，而且每次重启路由器这个IP会变化，我们还得等一段时间让DDNS生效，非常不便。

要是每个设备固定一个IP地址就好了，让我们在世界任何地方输入10.2.5.1这个IP就可以登录家里的路由、输入10.2.5.2就对应家里的智能开关、输入10.2.5.3就登陆自己的Android手机，即使它使用的是移动网络...

注: 上述的10.2.5.X只是一个内网地址的例子，和常见的192.168.1.X是一样的，使用这个地址段是为了避免N2N地址和常见的内网地址混淆。

N2N就是为此而生的，它是在数据链路层实现的一套P2P协议，目的是尽量简化设备直接的连接。

N2N的实现具有两个部分：supernode中心节点和edge边界节点， 边界节点通过中心节点找到对方，边界节点之间建立通信后，可以直接断开中心节点，实现点对点的加密通信


### **n2n服务器端安装**

首先要安装版本控制软件subversion

		yum install subversion

安装n2n软件

		svn co https://svn.ntop.org/svn/ntop/trunk/n2n
		cd n2n
		cd n2n_v1   /安装v1版的n2n
		make
		make install

这时会有两个命令，一个是supernode，一个是edge，supernode用于搭建服务器端，edge用于客户端。

#### **服务器端设置**

命令很简单：`supernode -l <listening port> `
		
		supernode -l 8888

#### **客户端的配置**

edge -a 你想设定的地址 -c 你的虚拟网络的名字 -k 虚拟网络的密码 -l 服务器的地址:端口

		edge -a 10.1.1.x -c chen-net -k password -l x.x.x.x:8888 &    /*后面这个&让edge后台运行

#### 将n2n添加到supervisor中运行

增加supervisor的ini文件：

		[program:n2n]
		command=edge -a 10.1.1.x -c chen-net -k password -l x.x.x.x:8888
		autostart=true
