# MariaDB 
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

# prevent apt from starting postgres right after the installation
RUN	echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN apt-get update
RUN locale-gen en_US.UTF-8
RUN LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get -y install python-software-properties
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu precise main'
RUN apt-get update
RUN LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get -y install mariadb-server

RUN cp /etc/mysql/my.cnf /etc/mysql/my.cnf.orig ;\
 sed -i '/^bind-address*/ s/^/#/' /etc/mysql/my.cnf ;\
 sed -i '/^datadir*/ s|/var/lib/mysql|/data/mysql|' /etc/mysql/my.cnf ;\
 mkdir -p /data ;\
 mv /var/lib/mysql /data/mysql

# allow autostart again
RUN	rm /usr/sbin/policy-rc.d

EXPOSE 3306 

#CMD ["/bin/bash"]

CMD ["/usr/bin/mysqld_safe"]
