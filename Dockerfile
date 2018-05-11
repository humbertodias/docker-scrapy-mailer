FROM ubuntu:18.04

RUN apt update \
&& apt install python3.7 python3-pip -y \
&& apt install cron dos2unix -y \
&& pip3 install scrapy service_identity mako premailer --force --upgrade

RUN useradd spider -d /home/spider
RUN mkdir /home/spider && chown spider /home/spider && gpasswd -a spider root && chmod 4777 /var/run && chmod 4777 /var/log && chmod 4755 /usr/sbin/cron
ADD spider /home/spider

RUN dos2unix /home/spider/*

RUN echo "spider:spider" | chpasswd
RUN echo "root:root" | chpasswd

USER spider

WORKDIR /home/spider

CMD ["/home/spider/schedule.sh"]
