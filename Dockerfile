FROM debian

RUN apt update \
&& apt install python python-pip cron -y \
&& pip install scrapy service_identity mako --force --upgrade

ADD spider /root
WORKDIR /root

CMD ["/root/schedule.sh"]