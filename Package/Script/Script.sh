#!/bin/sh

#  Script.sh
#  Package
#
#  Created by king on 2016/11/29.
#  Copyright © 2016年 king. All rights reserved.

echo "~~~~~~~~~~~~~~~~开始执行脚本~~~~~~~~~~~~~~~~"

####################################################################
###################工程信息以及最下面的蒲公英信息########################
#工程名
PROJECTPATH=${1}
#需要编译的 targetName
TARGET_NAME=${2}

#是否是工作空间
ISWORKSPACE="${3}"
####################################################################

#证书名
CODE_SIGN_IDENTITY=${4}
#描述文件
PROVISIONING_PROFILE_NAME=${5}


DATE=`date '+%Y-%m-%d-%T'`

#编译模式 工程默认有 Debug Release
CONFIGURATION_TARGET=${6}
#编译路径
BUILDPATH=~/Desktop/${TARGET_NAME}_${DATE}
#archivePath
ARCHIVEPATH=${BUILDPATH}/${TARGET_NAME}.xcarchive
#输出的ipa目录
IPAPATH=${BUILDPATH}

ExportOptionsPlist=${7}
# 是否上传蒲公英
UPLOADPGYER="${8}"


echo "~~~~~~~~~~~~~~~~开始编译~~~~~~~~~~~~~~~~~~~"

if [ $ISWORKSPACE = "1" ]
then
# 清理 避免出现一些莫名的错误
xcodebuild clean -workspace ${PROJECTPATH} \
-configuration \
${CONFIGURATION} -alltargets

#开始构建
xcodebuild archive -workspace ${PROJECTPATH} \
-scheme ${TARGET_NAME} \
-archivePath ${ARCHIVEPATH} \
-configuration ${CONFIGURATION_TARGET} \
CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
PROVISIONING_PROFILE="${PROVISIONING_PROFILE_NAME}"
else
# 清理 避免出现一些莫名的错误
xcodebuild clean -xcodeproj ${PROJECTPATH} \
-configuration \
${CONFIGURATION} -alltargets

#开始构建
xcodebuild archive -xcodeproj ${PROJECTPATH} \
-scheme ${TARGET_NAME} \
-archivePath ${ARCHIVEPATH} \
-configuration ${CONFIGURATION_TARGET} \
CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
PROVISIONING_PROFILE="${PROVISIONING_PROFILE_NAME}"
fi

echo "~~~~~~~~~~~~~~~~检查是否构建成功~~~~~~~~~~~~~~~~~~~"
# xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$ARCHIVEPATH" ]
then
echo "构建成功......"
else
echo "构建失败......"
rm -rf $BUILDPATH
exit 0
fi


echo "~~~~~~~~~~~~~~~~导出ipa~~~~~~~~~~~~~~~~~~~"

xcodebuild -exportArchive \
-archivePath ${ARCHIVEPATH} \
-exportOptionsPlist ${ExportOptionsPlist} \
-exportPath ${IPAPATH}

echo "~~~~~~~~~~~~~~~~检查是否成功导出ipa~~~~~~~~~~~~~~~~~~~"
IPAPATH=${IPAPATH}/${TARGET_NAME}.ipa
echo "${IPAPATH}"
exit 0
if [ -f "$IPAPATH" ]
then
echo "导出ipa成功......"
else
echo "导出ipa失败......"
exit 0
fi

# 上传蒲公英
if [ $UPLOADPGYER = "1" ]
then
	echo "~~~~~~~~~~~~~~~~上传ipa到蒲公英~~~~~~~~~~~~~~~~~~~"
	curl -F "file=@$IPAPATH" \
	-F "uKey=${9}" \
	-F "_api_key=${10}" \
	-F "password=${11}" \
	-F "isPublishToPublic=${12}" \
	https://www.pgyer.com/apiv1/app/upload --verbose

	if [ $? = 0 ]
	then
	echo "~~~~~~~~~~~~~~~~上传蒲公英成功~~~~~~~~~~~~~~~~~~~"
	exit 0
	else
	echo "~~~~~~~~~~~~~~~~上传蒲公英失败~~~~~~~~~~~~~~~~~~~"
	exit 0
	fi
else
	exit 0
fi


