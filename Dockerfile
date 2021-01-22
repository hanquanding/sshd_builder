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
