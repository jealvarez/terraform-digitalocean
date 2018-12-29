#!/bin/bash

sudo add-apt-repository -y ppa:certbot/certbot

sudo apt-get update -y

# Apache2
sudo apt-get install -y apache2

# Docker
sudo apt-get install -y docker.io

# Lets Encrypt
sudo apt-get install -y python-certbot-apache
