#!/bin/sh
# EasyGhost beta
# by Rytia
# Blog : www.zzfly.net
# 2015.7.4
clear
echo ""
echo "       -----------------------------------------"
echo "       |        Welcome to EasyGhost           |"
echo "       | To install Ghost blog in a simple way |"
echo "       -----------------------------------------"
echo ""
echo "        Powered by NodeJS + SQLite3 + LightTPD  "
echo "     Made by Rytia | http://www.zzfly.net/EasyGhost"
echo ""
read -p "Please input your Domain for Ghost blog " dm

##Install LightTPD SQLite3
apt-get remove -y apache*
apt-get install -y lighttpd
apt-get install -y sqlite3

cd /usr/local
##Check and download NodeJS
if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ] ; then
    wget https://raw.githubusercontent.com/colloq168/GhostZIP/master/node-v0.10.36-linux-x64.tar.gz
    tar xzvf node-v0.10.36-linux-x64.tar.gz
    rm -rf node-v0.10.36-linux-x64.tar.gz
    mv node-v0.10.36-linux-x64 node
else
    wget https://raw.githubusercontent.com/colloq168/GhostZIP/master/node-v0.10.36-linux-x86.tar.gz
    tar xzvf node-v0.10.36-linux-x86.tar.gz
    rm -rf node-v0.10.36-linux-x86.tar.gz
    mv node-v0.10.36-linux-x86 node
fi
echo 'export NODE_HOME=/usr/local/node' >> /etc/profile
echo 'export PATH=$NODE_HOME/bin:$PATH' >> /etc/profile
source /etc/profile
clear
echo '[Node.js version]'
node -v 

##Download Ghost blog
mkdir -p /ace/code/ghost
chown -R www:www /ace/code/ghost
cd /ace/code/ghost
wget https://raw.githubusercontent.com/colloq168/GhostZIP/master/Ghost-0.6.3-zh-full.zip
apt-get install -y unzip
unzip Ghost-0.6.3-zh-full.zip
wget https://raw.githubusercontent.com/colloq168/GhostZIP/master/config.js
##Config Ghost
sed -i "s/EasyGhost/"$dm"/g" 'config.js'

## Finish Ghost blog
npm install forever -g
NODE_ENV=production forever start index.js

##Config vhost
cd /etc/lighttpd
mv lighttpd.conf old.conf
wget https://raw.githubusercontent.com/colloq168/GhostZIP/master/lighttpd.conf
sed -i "s/EasyGhost/"$dm"/g" 'lighttpd.conf'
service lighttpd restart

echo ""
echo "--------------------------------------------"
echo '[Finished]'
echo 'Files: /ace/code/ghost'
echo 'Database: /ace/code/ghost/content/data/ghost.db'
echo 'Congratulations! You can access your Ghost blog now!'
