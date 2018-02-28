FROM python

RUN apt update \
&& apt install cron dos2unix -y \
&& pip install scrapy service_identity mako --force --upgrade

RUN useradd spider -d /home/spider
RUN mkdir /home/spider && chown spider /home/spider && gpasswd -a spider root && chmod 4777 /var/run && chmod 4777 /var/log && chmod 4755 /usr/sbin/cron
ADD spider /home/spider

RUN dos2unix /home/spider/*

USER spider
#RUN echo "spider:spider" | chpasswd

WORKDIR /home/spider

CMD ["/home/spider/schedule.sh"]