#!/bin/sh


path=$PWD/Package
echo "$path"
if [ -d "/usr/local/Package" ]
then 
sudo rm -rf /usr/local/Package
else
# 拷贝文件 
sudo cp -R $path /usr/local
# 修改执行权限
sudo chmod +x  /usr/local/Package/Script/Script.sh
sudo chmod +x  /usr/local/Package/Script/init.sh
# 建立软连
sudo ln -s /usr/local/Package/bin/Package /usr/local/bin 
fi