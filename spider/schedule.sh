#!/bin/sh

waitForRequiredVariable(){

	while true; do 

		if [ -z "${CRON_SCHEDULE}" ]; then
		    echo "$(date +"%T") CRON_SCHEDULE is unset or set to the empty string"
		else
			break
		fi

		sleep 5; 

	done

}

waitForRequiredVariable

cat <<EOT >> /home/spider/.bashrc
export MAIL_SMTP_HOST="$MAIL_SMTP_HOST"
export MAIL_SMTP_PORT="$MAIL_SMTP_PORT"
export MAIL_FROM="$MAIL_FROM"
export MAIL_FROM_PASSWORD="$MAIL_FROM_PASSWORD"
export MAIL_TO="$MAIL_TO"
export MAIL_SUBJECT="$MAIL_SUBJECT"
export MAIL_TEXT="$MAIL_TEXT"
export CRON_SCHEDULE="$CRON_SCHEDULE"
export PATH=$PATH:/usr/local/bin
EOT
LOG_FILE=/var/log/cron_spider.log
> $LOG_FILE

crontab -l | { cat; echo "$CRON_SCHEDULE /home/spider/mail.sh >> $LOG_FILE 2>&1"; } | crontab -
cron & 

echo "Waiting for next schedule of cron [$CRON_SCHEDULE]"
tail -f $LOG_FILE