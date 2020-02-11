FROM base-mrm 
MAINTAINER SharxDC

COPY sharx.repo /etc/yum.repos.d/
COPY stnebula.sh /entrypoint.sh
COPY gosu /usr/bin/gosu
RUN yum -y install --setopt=tsflags=nodocs epel-release && \
    yum -y install --setopt=tsflags=nodocs yum-utils \
                                           rubygem-rack \
                                           memcached && \
    yum clean all && \
    yum-config-manager --disable epel && \
    yum -y install --setopt=tsflags=nodocs passenger \
                                           nginx && \
    yum -y update && yum clean all && \
    /bin/chmod +x /entrypoint.sh /usr/bin/gosu && \    
    usermod -a -G nginx oneadmin && \
    chmod -R 770 /var/lib/nginx /var/log/nginx && \
    rm -rf /etc/nginx/nginx.conf /var/log/nginx/* /var/log/one/* /etc/nginx/conf.d/nginx.conf
    
COPY passenger.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/

EXPOSE 80 29876

#USER 9869

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
