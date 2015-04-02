#!/bin/bash
set -e

openssl genrsa -out redmine.key 2048
openssl req -new -key redmine.key -out redmine.csr
openssl x509 -req -days 365 -in redmine.csr -signkey redmine.key -out redmine.crt
