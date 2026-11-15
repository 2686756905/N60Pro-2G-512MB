# 上游仓库

https://github.com/VIKINGYFY/OpenWRT-CI

# 本地编译器

https://github.com/VIKINGYFY/OWRT-Tools.git

# 自用修改版插件

https://github.com/VIKINGYFY/packages.git

# OpenWRT-CI

官方版：

https://github.com/immortalwrt/immortalwrt.git

自用版：

https://github.com/VIKINGYFY/immortalwrt.git

# U-BOOT

高通版-沉心：

https://github.com/chenxin527/uboot-qsdk12.5-build.git

高通版-小猪：

https://github.com/1980490718/u-boot-2016.git

联发科-全新版：

https://github.com/VIKINGYFY/UBOOT-CI/releases

联发科-官方版：

https://drive.wrt.moe/uboot/mediatek

# 固件简要说明

【基础信息】

目标机型：Netcore N60 Pro (MT7986A)

硬件适配：完美识别 2GB 内存，UBI 分区扩容至 506.5MB（可用 overlay 空间约 368MB+）。

软件底层：ImmortalWrt SNAPSHOT (原生 apk 包管理器，非旧版 opkg)。

默认 IP：192.168.10.1 / 无密码。

【核心特性与插件】

🚀 双代理核心：内置 Honk (基于 eBPF 的高性能透明代理) 与 Nikki (Mihomo 内核图形界面)。

⚙️ 完美环境：已开启 BTF/eBPF 内核支持，预装 yq YAML 解析工具，插件即开即用，告别环境报错。

🔥 硬件加速：集成 kmod-cryptodev 与 kmod-tls，代理加解密直接调用 MT7986 硬件加速，大幅降低 CPU 占用。

【极致精简（已物理剔除）】

拒绝全家桶，去除了 Network Shares (Samba)、WOL Ultra、Gecoos AC、HomeProxy、NATMap 等无用组件，系统极度纯净。

【特色优势】

🌐 内置官方源：固件已预制 Honk 官方公钥与软件源（@daeuniverse），日后可通过 SSH 执行 apk update && apk upgrade 直接在线热更新 Honk，无需重新刷机。

【⚠️ 刷机与使用必看】

刷机必擦除：由于分区表已修改，U-Boot 刷机前必须先点击“擦除UBI分区”，否则无法启动。

5G Wi-Fi 修复：若开机搜不到 5G 信号，请进入“网络-无线”，将 5G 信道改为 149，国家代码改为 CN，保存应用即可。

装包命令：安装第三方 .apk 文件时，若提示签名错误，请使用 apk add --allow-untrusted /tmp/xxx.apk。

# 目录简要说明

workflows——自定义CI配置

Scripts——自定义脚本

Config——自定义配置

## Star History

<a href="https://www.star-history.com/?repos=vikingyfy%2Fopenwrt-ci&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&legend=top-left" />
 </picture>
</a>
