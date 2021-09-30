FROM ubuntu:14.04

ARG installation_script_dir
ARG pkg_url
ARG pkg_name
ARG multinode_conf_generator

ENV HOME "/home/graphsql/"
ENV INSTALLATION_DIR $HOME_DIR"installation/"
ENV NOTVISIBLE "in users profile"
WORKDIR $HOME

EXPOSE 22 5000-50000 
COPY $installation_script_dir $INSTALLATION_DIR

RUN set -x && useradd -ms /bin/bash graphsql && \
    apt-get update && \
    apt-get install -y sudo net-tools wget sysvinit-utils curl vim man faketime unzip iptables iputils-ping logrotate openssh-client expect openssh-server psmisc gdb && \
    bash $INSTALLATION_DIR"general_off_install.sh" $pkg_url $pkg_name && \
    mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    echo "root:graphsql" | chpasswd && \
    echo "graphsql:graphsql" | chpasswd && \
    chown -R graphsql:graphsql $INSTALLATION_DIR && \
    mkdir -p /home/graphsql/graphsql_coredump && \
    chown graphsql:graphsql /home/graphsql/graphsql_coredump && \
    echo "source /home/graphsql/.bash_tigergraph || :" >> /home/graphsql/.bashrc

# default user
# USER graphsql

CMD "${INSTALLATION_DIR}utils/entrypoint.sh"

