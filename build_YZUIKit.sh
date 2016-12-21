#!/bin/bash
clear;
CONFIG="Debug"
ARG="Debug"
SIMULATORSDK="iphonesimulator"
IPHONESDK="iphoneos"

#用 -c Debug(c：表示必传的参数，如果不需要c，就不使用)
while getopts ":c:v:" OPTION
do
    case $OPTION in
        c)ARG=$OPTARG
          ;;
        v)
            SIMULATORSDK=${SIMULATORSDK}${OPTARG}
            IPHONESDK=${IPHONESDK}${OPTARG}
            ;;
        ?)echo "error options,not support. please use \"-c\""
           exit 1;;
    esac
done

echo "sdks:  $SIMULATORSDK,$IPHONESDK"

if [ "$ARG" = "Release" -o "$ARG" = "Debug" ];then
    CONFIG=$ARG
    echo "configuration is $CONFIG"
else
    exit 1
fi


if [[ $? -eq 0 ]];then
echo ""
else
exit 1
fi

xcodebuild clean -project YZUIKit/YZUIKit.xcodeproj -sdk $IPHONESDK -configuration $CONFIG
xcodebuild -project YZUIKit/YZUIKit.xcodeproj -sdk $IPHONESDK -configuration $CONFIG

if [[ $? -eq 0 ]];then
echo ""
else
exit 1
fi

xcodebuild clean -project YZUIKit/YZUIKit.xcodeproj -sdk $SIMULATORSDK -configuration $CONFIG
xcodebuild -project YZUIKit/YZUIKit.xcodeproj -sdk $SIMULATORSDK -configuration $CONFIG

#
lipo -create library/framework-iphoneos/YZUIKit.framework/YZUIKit library/framework-iphonesimulator/YZUIKit.framework/YZUIKit -output library/YZUIKit
##方式一，真机framework是通用的framework
#cp ./library/YZUIKit ./library/framework-iphoneos/YZUIKit.framework

##方式二
mv ./library/YZUIKit ./library/framework-iphoneos/YZUIKit.framework/
cp -rf ./library/framework-iphoneos/* ./
chmod u-w YZUIKit.framework/Headers/*
rm -rf ./library/


