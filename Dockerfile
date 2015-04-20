# Reference:
# http://github.com/sameersbn/docker-redmine  
# http://github.com/phusion/baseimage-docker 
FROM phusion/baseimage:0.9.16
MAINTAINER Rob Lao "viewpl@gmail.com" 

ENV HOME /root

RUN echo 'root:jSWew3Zxh4~' | chpasswd

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

ADD key.pub /root/.ssh/authorized_keys

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C3173AA6 \
 && echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv C300EE8C \
 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y wget supervisor logrotate nginx mysql-server mysql-client postgresql-client \
      imagemagick subversion git cvs bzr mercurial rsync ruby2.1 locales openssh-client \
      gcc g++ make patch pkg-config ruby2.1-dev libc6-dev \
      libmysqlclient18 libpq5 libyaml-0-2 libcurl3 libssl1.0.0 \
      libxslt1.1 libffi6 zlib1g \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && gem install --no-document bundler 

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/config/ /app/setup/config/
ADD assets/init /app/init
RUN chmod 755 /app/init

RUN mkdir /etc/service/mysql
ADD runmysql.sh /etc/service/mysql/run
RUN chmod +x /etc/service/mysql/run

RUN mkdir /etc/service/redmine
ADD runredmine.sh /etc/service/redmine/run
RUN chmod +x /etc/service/redmine/run

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
EXPOSE 443

VOLUME ["/var/lib/mysql"]
VOLUME ["/home/redmine/data"]
VOLUME ["/var/log/redmine"]

CMD ["/sbin/my_init"]
