#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

FEEDS_PATH="./feeds"
PACKAGE_PATH="./package"

#修补命令统一入口：FIX <名称> <守卫目录> <命令...>
#守卫目录不存在时直接跳过，保证在 bash -e 下不中断
FIX() {
	local NAME=$1
	local GUARD=$2
	shift 2

	[ -d "$GUARD" ] || return 0

	echo " "
	if "$@"; then
		echo "$NAME has been fixed!"
	else
		echo "$NAME fix failed; continuing!"
	fi
}

#修改argon主题字体和颜色
FIX "theme-argon" "$PACKAGE_PATH/luci-theme-argon" sed -i \
	"s/primary '.*'/primary '#31a1a1'/g; s/'0.2'/'0.5'/g; s/'none'/'bing'/g; s/'600'/'normal'/g" \
	"$PACKAGE_PATH/luci-theme-argon/luci-app-argon-config/root/etc/config/argon"

#修改aurora菜单式样
FIX "theme-aurora" "$PACKAGE_PATH/luci-app-aurora-config" find \
	"$PACKAGE_PATH/luci-app-aurora-config/root/usr/share/aurora/" -type f -name '*.template' -exec sed -i \
	"s/nav_type '.*'/nav_type 'dropdown'/g; s/struct_radius_base '.*'/struct_radius_base '0.125rem'/g" {} +

#修改vantage进度条标签字体（anothaDev/luci-theme-vantage#52）
FIX "theme-vantage" "$PACKAGE_PATH/luci-theme-vantage" sed -i \
	-e '/^\/\* progress bars: thin track/,$ { /^\.cbi-progressbar::before {/,/^}/ { s/^[[:space:]]*font: 500 var(--fs-micro)\/1\.2 var(--mono);/\tfont: inherit; line-height: normal;/; } }' \
	"$PACKAGE_PATH/luci-theme-vantage/luci-theme-vantage/htdocs/luci-static/vantage/vantage.css"

#修改mini-diskmanager菜单位置
FIX "mini-diskmanager" "$PACKAGE_PATH/luci-app-mini-diskmanager" sed -i "s/services/system/g" \
	"$PACKAGE_PATH/luci-app-mini-diskmanager/luci-app-mini-diskmanager/root/usr/share/luci/menu.d/luci-app-mini-diskmanager.json"

#修改natmapt菜单位置
FIX "natmapt" "$PACKAGE_PATH/luci-app-natmapt" sed -i "s/network/services/g" \
	"$PACKAGE_PATH/luci-app-natmapt/root/usr/share/luci/menu.d/luci-app-natmap.json"

# ==========================================
# 1. 修复框架自带的权限报错
# ==========================================
chmod +x /home/runner/work/*/*/.github/scripts/collect-build-reports.sh 2>/dev/null || true

# ==========================================
# 2. 磊科 N60 Pro 硬改适配：2G 内存 + 506.5M UBI
# ==========================================
DTS_FILE="target/linux/mediatek/dts/mt7986a-netcore-n60-pro.dts"

if [ -f "$DTS_FILE" ]; then
    echo "开始修改 N60 Pro 设备树..."
    sed -i 's/reg = <0 0x40000000 0 0x20000000>;/reg = <0 0x40000000 0 0x80000000>;/' "$DTS_FILE"
    sed -i '/label = "ubi"/ { n; s/reg = <[^>]*>;/reg = <0x580000 0x1FA80000>;/ }' "$DTS_FILE"
    echo "✅ N60 Pro DTS 修改完成（2G RAM + 506.5M UBI）"
else
    echo "❌ 警告：未找到 DTS 文件，请检查源码路径！"
fi

# ==========================================
# 3. 强制写入内核 BTF 参数 (防覆盖)
# ==========================================
echo "CONFIG_KERNEL_DEBUG_INFO=y" >> .config
echo "CONFIG_KERNEL_DEBUG_INFO_BTF=y" >> .config
echo "CONFIG_KERNEL_DEBUG_INFO_REDUCED=n" >> .config
echo "CONFIG_DWARVES=y" >> .config

# ==========================================
# 4. 全盘物理删除不需要的插件源码 (终极绝杀)
# ==========================================
echo "正在物理清除不需要的插件..."
find . -type d \( -name "luci-app-homeproxy" -o -name "luci-app-samba4" -o -name "luci-app-ksmbd" \) -exec rm -rf {} + 2>/dev/null
find . -type d \( -name "luci-app-wol" -o -name "luci-app-wolultra" -o -name "luci-app-timewol" \) -exec rm -rf {} + 2>/dev/null
find . -type d \( -name "luci-app-gecoosac" -o -name "gecoosac" -o -name "luci-i18n-gecoosac-zh-cn" \) -exec rm -rf {} + 2>/dev/null
find . -type d \( -name "luci-app-natmapt" -o -name "natmapt" -o -name "luci-i18n-natmapt-zh-cn" \) -exec rm -rf {} + 2>/dev/null

# ==========================================
# 5. 添加 Nikki 的 feeds 源
# ==========================================
echo "正在添加 Nikki feeds 源..."
grep -q "OpenWrt-nikki" feeds.conf.default || echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> feeds.conf.default

# ==========================================
# 6. 拉取 Honk 源码
# ==========================================
echo "正在拉取 honk 源码..."
git clone --depth=1 https://github.com/kenzok8/openwrt-honk.git package/openwrt-honk

# ==========================================
# 7. 集成 Honk 官方 apk 软件源与公钥 (方便日后在线更新)
# ==========================================
echo "正在集成 honk 官方软件源..."
mkdir -p package/base-files/files/etc/apk/keys
mkdir -p package/base-files/files/etc/apk/repositories.d

# 下载官方公钥
wget -O package/base-files/files/etc/apk/keys/daeuniverse.pem https://openwrt.daeuniverse.org/public-key.pem

# 写入软件源配置 (已适配你的 aarch64 架构与 snapshot 版本)
cat > package/base-files/files/etc/apk/repositories.d/daeuniverse.list << 'EOF'
@daeuniverse https://openwrt.daeuniverse.org/snapshot/packages/aarch64_cortex-a53/packages.adb
EOF
