#!/bin/bash
set -e

if [ ! -f ./redmine.crt ]; then
    echo "Please use './gen-ssl-cert.sh' to generate a self-signed ssl certificate at first..."
    exit 1
fi

mkdir -p /opt/mysql/data
mkdir -p /opt/redmine/data

docker run -p 443:443 -d --name=redmine \
	-e REDMINE_HTTPS=true \
	-e REDMINE_HTTPS_HSTS_MAXAGE=31536000 \
	-e DB_NAME=redmine_production \
	-e DB_USER=redmine \
	-e DB_PASS=5adT$x6Z3TP \
	#-e SMTP_USER=[your email] \
	#-e SMTP_PASS=[your password] \
	-e SSL_CERTIFICATE_PATH=/home/redmine/data/certs/redmine.crt \
	-e SSL_KEY_PATH=/home/redmine/data/certs/redmine.key \
	-e SSL_DHPARAM_PATH=/home/redmine/data/certs/dhparam.pem \
	-v /opt/mysql/data:/var/lib/mysql \
	-v /opt/redmine/data:/home/redmine/data viewpl/redmine
