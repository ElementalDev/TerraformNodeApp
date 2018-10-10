#!/bin/bash

export DB_HOST=mongodb://${database_ip}:27017/posts
cd /home/ubuntu/app
node seeds/seed.js
pm2 kill
pm2 start app.js
