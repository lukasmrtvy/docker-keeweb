FROM alpine:latest

RUN apk add --no-cache -U openssl wget unzip nginx ca-certificates && update-ca-certificates

RUN rm -rf /etc/nginx/conf.d/*; \
    mkdir -p /etc/nginx/external /run/nginx/

RUN sed -i 's/access_log.*/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf; \
    sed -i 's/error_log.*/error_log \/dev\/stdout info;/g' /etc/nginx/nginx.conf; \
    sed -i 's/^pid/daemon off;\npid/g' /etc/nginx/nginx.conf

ADD keeweb.conf /etc/nginx/conf.d/keeweb.conf

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

RUN wget https://github.com/keeweb/keeweb/archive/gh-pages.zip; \
    unzip gh-pages.zip; \
    rm gh-pages.zip; \
    mv keeweb-gh-pages keeweb; \
    rm keeweb/CNAME

RUN wget https://github.com/keeweb/keeweb-plugins/archive/master.zip; \
    unzip master.zip; \
    rm master.zip; \
    mv keeweb-plugins-master/docs keeweb/plugins; \
    rm -rf keeweb-plugins-master \
    rm keeweb/plugins/CNAME

EXPOSE 443
EXPOSE 80

LABEL version=""
LABEL url=https://github.com/keeweb/keeweb


ENTRYPOINT ["/opt/entrypoint.sh"]

CMD /usr/sbin/nginx -g "daemon off;"
