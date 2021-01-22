# 镜像SSH服务

###### 创建目录和文件
```
mkdir sshd_builder
cd sshd_builder
touch Dockerfile run.sh
```
###### 编写run.sh脚本和authorized_keys文件
```
#run.sh
#!/bin/bash
/usr/sbin/sshd -D
```

```
cat ~/.ssh/id_rsa.pub  >authorized_keys
```

###### 编写Dockerfile文件
```
# 基础镜像
FROM ubuntu:18.04

# 维护者   
LABEL maintainer hqd<545922113@qq.com>

# 更换为163源码
RUN echo "deb http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse"            > /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse"   >> /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse"    >> /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse"   >> /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse"  >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse"        >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse"   >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse"    >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse"   >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse"  >> /etc/apt/sources.list

RUN apt-get update 

# 安装ssh服务
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh

# 取消pam限制
RUN sed  -ri 's/session  required pam_loginuid.so/#session  required  pam_loginuid.so/g'  /etc/pam.d/sshd

# 复制文件到容器
ADD authorized_keys  /root/.ssh/authorized_keys
ADD run.sh           /run.sh

# 修改执行权限
RUN chmod 755        /run.sh

# 开放端口
EXPOSE 22

# 设置自启动命令
CMD [ "/run.sh" ]
```

###### 创建镜像
```
cd sshd_builder
docker build -t sshd_ubuntu:v1 .
```

###### 运行容器
```
docker run -d  -p 2222:22 sshd_ubuntu
```

###### 连接容器
```
ssh 192.168.0.200 -p 2222
```





