#!/bin/bash

# 检查变量是否有值
function arg_has_value() {
    local name=$1
    if [ "${!name}" == "" ]; then
        echo "$name 没有定义！"
        exit 1
    fi
}

# 参数获取
while getopts ":s:n:d:" opt; do
    case $opt in
    s)
        SECRET_NAME="$OPTARG"
        echo "SECRET_NAME: $OPTARG"
        ;;
    n)
        NAMESPACE="$OPTARG"
        echo "NAMESPACE: $OPTARG"
        ;;
    d)
        DOMAIN="$OPTARG"
        echo "DOMAIN: $OPTARG"
        ;;
    ?)
        echo "未知参数"
        exit 1
        ;;
    esac
done

arg_has_value SECRET_NAME
arg_has_value NAMESPACE
arg_has_value DOMAIN

# 获取本脚本的绝对路径
if [[ $0 =~ ^\/.* ]]; then
    script=$0
else
    script=$(pwd)/$0
fi
script_abs_dir=${script%/*}

mkdir -p $DOMAIN

# 获取acme.sh的路径
acmesh_path=""
if [ -e "$HOME/.acme.sh/acme.sh" ]; then
    acmesh_path="$HOME/.acme.sh/acme.sh"
fi
if [ "$acmesh_path" == "" ]; then
    echo "找不到 acme.sh 的路径"
    exit 1
fi
echo "acmesh_path: $acmesh_path"

# 保存变量
echo -e "SECRET_NAME=$SECRET_NAME\nNAMESPACE=$NAMESPACE" >$script_abs_dir/$DOMAIN/env.conf

$acmesh_path --install-cert -d $DOMAIN \
    --key-file $script_abs_dir/$DOMAIN/tls.key \
    --cert-file $script_abs_dir/$DOMAIN/tls.cert \
    --reloadcmd "bash $script_abs_dir/reload-cert.sh $DOMAIN"
