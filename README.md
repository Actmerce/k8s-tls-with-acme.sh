## acme.sh 配合 k8s tls secret 的使用

### 前期准备

#### 安装 acme.sh

参考： https://github.com/acmesh-official/acme.sh

```bash
curl  https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh
```

#### 配置 acme.sh

使用dns的方式，自动更新证书


```bash
export Ali_Key="{{ALI_KEY}}"
export Ali_Secret="{{ALI_SECRET}}"

acme.sh --issue --dns dns_ali -d {{HOST}}

# Ali_Key 以及 Ali_Secret 将会被保存在 ~/.acme.sh/account.conf
```

也可以使用手动更新的方式来对证书进行更新

```
acme.sh --renew -d {{HOST}}
```

### 脚本的使用

```bash
# clone 代码，进入项目根目录
git clone git@github.com:Actmerce/k8s-tls-with-acme.sh.git
cd tls-secrets

# 安装证书
bash install-cert.sh -s {{SECRET_NAME}} -n {{NAMESPACE}} -d {{HOST}}
```

