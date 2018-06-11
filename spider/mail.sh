#!/bin/sh

. /home/spider/.bashrc

checkRequiredVariables(){
	exit_code=0
	if [ -z "${MAIL_FROM}" ]; then
	    echo "MAIL_FROM is unset or set to the empty string" 
	    exit_code=1
	fi
	if [ -z "${MAIL_FROM_PASSWORD}" ]; then
	    echo "MAIL_FROM_PASSWORD is unset or set to the empty string"
	    exit_code=2
	fi
	if [ -z "${MAIL_TO}" ]; then
	    echo "MAIL_TO is unset or set to the empty string"
	    exit_code=3
	fi
	if [ -z "${MAIL_SUBJECT}" ]; then
	    echo "MAIL_SUBJECT is unset or set to the empty string"
	    exit_code=4
	fi
	if [ -z "${MAIL_TEXT}" ]; then
	    echo "MAIL_TEXT is unset or set to the empty string"
	    exit_code=5
	fi
	if [ -z "${MAIL_SMTP_HOST}" ]; then
	    echo "MAIL_SMTP_HOST is unset or set to the empty string"
	    exit_code=6
	fi
	if [ -z "${MAIL_SMTP_PORT}" ]; then
	    echo "MAIL_SMTP_PORT is unset or set to the empty string"
	    exit_code=7
	fi
	return $exit_code
}

scrapySenacAndSendMail(){
	JSON_FILE_NAME="senac-$(date +'%Y-%m-%d_%T').json"
	scrapy runspider senac.py -o "$JSON_FILE_NAME" --logfile /var/log/scrapy_spider.log
	python3 mail.py \
	--smtp_host "$MAIL_SMTP_HOST" \
	--smtp_port "$MAIL_SMTP_PORT" \
	--from "$MAIL_FROM" \
	--pass "$MAIL_FROM_PASSWORD" \
	--to "$MAIL_TO" \
	--subject "$MAIL_SUBJECT" \
	--text "$MAIL_TEXT" \
	--json "$JSON_FILE_NAME"
}

scrapyJnJAndSendMail(){
	JSON_FILE_NAME="jnj-$(date +'%Y-%m-%d_%T').json"
	scrapy runspider jnj.py -o "$JSON_FILE_NAME" --logfile /var/log/scrapy_spider.log
	python3 mail.py \
	--smtp_host "$MAIL_SMTP_HOST" \
	--smtp_port "$MAIL_SMTP_PORT" \
	--from "$MAIL_FROM" \
	--pass "$MAIL_FROM_PASSWORD" \
	--to "$MAIL_TO" \
	--subject "$MAIL_SUBJECT" \
	--text "$MAIL_TEXT" \
	--json "$JSON_FILE_NAME"
}

scrapyAndSendMail(){
	scrapySenacAndSendMail
	scrapyJnJAndSendMail
}

checkRequiredVariables
if [ "$?" = "0" ]; then
	scrapyAndSendMail
else
	echo "Some required variabled is unset"
fi