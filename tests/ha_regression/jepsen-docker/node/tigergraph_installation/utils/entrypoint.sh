#! /bin/bash

touch /home/graphsql/.ssh/authorized_keys || :
echo "${AUTHORIZED_KEYS}" >> /home/graphsql/.ssh/authorized_keys
chmod 600 /home/graphsql/installation/.ssh/authorized_keys
/usr/sbin/sshd -D
