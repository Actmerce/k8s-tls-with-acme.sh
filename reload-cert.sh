#!/bin/bash

# 获取本脚本的绝对路径
if [[ $0 =~ ^\/.* ]]; then
    script=$0
else
    script=$(pwd)/$0
fi
script_abs_dir=${script%/*}

DOMAIN=$1

# 生成yaml
cp $script_abs_dir/templates/tls-secret.yaml $script_abs_dir/$DOMAIN
python3 $script_abs_dir/yaml-format.py $script_abs_dir/$DOMAIN

# 执行
kubectl apply -f $script_abs_dir/$DOMAIN/tls-secret.yaml
