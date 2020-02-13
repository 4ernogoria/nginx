FROM base-mrm 
MAINTAINER SharxDC

COPY sharx.repo /etc/yum.repos.d/
COPY stnebula.sh /entrypoint.sh
#COPY gosu /usr/bin/gosu
RUN yum -y install --setopt=tsflags=nodocs epel-release && \
    yum -y install --setopt=tsflags=nodocs yum-utils \
                                           rubygem-rack \
                                           memcached && \
    yum clean all && \
    yum-config-manager --disable epel && \
    yum -y install --setopt=tsflags=nodocs passenger \
                                           nginx && \
    yum -y update && yum clean all && \
    rm -rf /etc/nginx/nginx.conf /var/log/nginx/* /var/log/one/* /etc/nginx/conf.d/nginx.conf

COPY passenger.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/

RUN /bin/chmod +x /entrypoint.sh /usr/bin/gosu && \    
    usermod -a -G nginx oneadmin && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/log/nginx /etc/nginx/conf.d /var/lib/nginx /var/run/nginx.pid /var/run/passenger-instreg && \
    chmod -R 770 /var/lib/nginx /var/log/nginx /var/run/nginx.pid /etc/nginx/conf.d && \
    chown -R 9869:9869 /var/run/passenger-instreg
    
EXPOSE 80 29876

USER 9869

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
