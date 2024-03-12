FROM mattermost/focalboard:7.11.3

USER root
RUN apt-get update -y && \
    apt-get install -y curl wget gnupg2 nginx

RUN rm -rf /etc/nginx/conf.d/*.conf

COPY focalboard.conf /etc/nginx/conf.d/focalboard.conf

COPY config.json /opt/focalboard/config.json

EXPOSE 80 8000 9092

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
