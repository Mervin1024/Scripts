#!/usr/bin/env bash

#将xm和文件app包放在同一个目录，运行本脚步进行注入

path=`ls | grep *.app | head -1`
tweak=`ls | grep *.xm | head -1`
temp='x11901'
name=${path%.app}

$THEOS/bin/logos.pl "./${tweak}" > "./${temp}.m"
clang -shared -undefined dynamic_lookup -o "./${path}/Contents/MacOS/lib.dylib" "./${temp}.m"
optool install -c load -p @executable_path/lib.dylib -t "./${path}/Contents/MacOS/${name}"

rm -f ${temp}.m

# 使用unsign或者optool效果可能更好，codesign --remove-signature 在删除代码签名之后没有修复MachO Header的偏移，导致生成的MachO文件畸形
# codesign --remove-signature ${name}