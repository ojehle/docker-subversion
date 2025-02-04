FROM murks/docker-apache2-ssl-secure
MAINTAINER MarvAmBass

ENV LANG C.UTF-8

COPY apt/sources.list /etc/apt/sources.list

RUN apt-get -y update && apt-get install -y \
    subversion \
    cron \
    libapache2-mod-svn 

RUN a2enmod dav_svn
RUN a2enmod auth_digest

RUN mkdir /var/svn-backup
RUN mkdir -p /var/local/svn
RUN mkdir /etc/apache2/dav_svn

ADD files/dav_svn.conf /etc/apache2/mods-available/dav_svn.conf

ADD files/svn-backuper.sh /usr/local/bin/
ADD files/svn-project-creator.sh /usr/local/bin/
ADD files/svn-entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/svn*

RUN echo "*/10 * * * *	root    /usr/local/bin/svn-project-creator.sh" >> /etc/crontab
RUN echo "0 0 * * *	root    /usr/local/bin/svn-backuper.sh" >> /etc/crontab

RUN sed -i '/#\!.*$/a \/usr\/local\/bin/svn-entrypoint.sh'  /container/scripts/entrypoint.sh

VOLUME ["/var/local/svn", "/var/svn-backup", "/etc/apache2/dav_svn"]
