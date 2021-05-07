#!/bin/sh
#openssl genrsa -des3 -out certs/server.key 2048

# Generate Certificate Signing Request:
#openssl req -new -key certs/server.key -sha256 -out certs/server.csr

# Generate a Self-Signed Certificate:
#openssl x509 -req -days 365 -in certs/server.csr -signkey certs/server.key -sha256 -out certs/server.crt

# Convert the CRT to PEM format:
#openssl x509 -in certs/server.crt -out certs/server.pem -outform PEM


openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
openssl x509 -text -noout -in certificate.pem
cat certificate.pem  key.pem >server.pem
