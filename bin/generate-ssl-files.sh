#!/usr/bin/env bash

set -e

CERT_PASS=${KEYTOOL_CERT_PASS:-changeit}

SUBJ_C=${OPENSSL_SUBJ_C:-JP}
SUBJ_ST=${OPENSSL_SUBJ_ST:-Tokyo}
SUBJ_L=${OPENSSL_SUBJ_L:-}
SUBJ_O=${OPENSSL_SUBJ_O:-}
SUBJ_OU=${OPENSSL_SUBJ_OU:-}
SUBJ_CN=${OPENSSL_SUBJ_CN:-localhost}

SSL_FILES_DIR="/etc/private/ssl"
SERVER_KEYSTORE_FILENAME="server.keystore.jks"
SERVER_TRUSTSTORE_FILENAME="server.truststore.jks"
CLIENT_TRUSTSTORE_FILENAME="client.truststore.jks"

mkdir -p $SSL_FILES_DIR && cd $SSL_FILES_DIR

keytool \
    -noprompt \
    -storepass $CERT_PASS \
    -keystore $SERVER_KEYSTORE_FILENAME \
    -alias localhost \
    -validity 365 \
    -genkeypair \
    -keyalg RSA \
    -dname "CN=$SUBJ_CN, OU=$SUBJ_OU, O=$SUBJ_O, L=$SUBJ_L, S=$SUBJ_ST, C=$SUBJ_C"

openssl req \
    -new \
    -x509 \
    -keyout ca-key \
    -out ca-cert \
    -passout pass:$CERT_PASS \
    -days 365 \
    -subj "/C=$SUBJ_C/ST=$SUBJ_ST/L=$SUBJ_L/O=$SUBJ_O/OU=$SUBJ_OU/CN=$SUBJ_CN"

keytool \
    -noprompt \
    -storepass $CERT_PASS \
    -keystore $SERVER_TRUSTSTORE_FILENAME \
    -alias CARoot \
    -import \
    -file ca-cert

keytool \
    -noprompt \
    -storepass $CERT_PASS \
    -keystore $CLIENT_TRUSTSTORE_FILENAME \
    -alias CARoot \
    -import \
    -file ca-cert

keytool \
    -noprompt \
    -storepass $CERT_PASS \
    -keystore $SERVER_KEYSTORE_FILENAME \
    -alias localhost \
    -certreq \
    -file cert-file

openssl x509 \
    -req \
    -CA ca-cert \
    -CAkey ca-key \
    -in cert-file \
    -passin pass:$CERT_PASS \
    -out cert-signed \
    -days 365 \
    -CAcreateserial

keytool \
    -noprompt \
    -storepass $CERT_PASS \
    -keystore $SERVER_KEYSTORE_FILENAME \
    -alias CARoot \
    -import \
    -file ca-cert

keytool \
    -noprompt \
    -storepass $CERT_PASS \
    -keystore $SERVER_KEYSTORE_FILENAME \
    -alias localhost \
    -import \
    -file cert-signed
