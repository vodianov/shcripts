#! /usr/bin/env bash

openssl aes-256-cbc -d -a -in ~/.ssh/$1.enc -out ~/.ssh/$1
