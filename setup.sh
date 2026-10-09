
#!/usr/bin/env bash
set -Eeuo pipefail

: "${KERNEL_ROOT:?ABK 未提供 KERNEL_ROOT}"
: "${DEFCONFIG:?ABK 未提供 DEFCONFIG}"

# ABK 的 GKI 内核源码通常位于 common/ 下
KROOT="${KERNEL_ROOT}/common"

if [[ ! -f "${KROOT}/Makefile" ]]; then
    echo "[NoMount] 找不到内核 Makefile: ${KROOT}"
    exit 1
fi

if [[ ! -f "${DEFCONFIG}" ]]; then
    echo "[NoMount] 找不到 defconfig: ${DEFCONFIG}"
    exit 1
fi

echo "[NoMount] Kernel root: ${KROOT}"
echo "[NoMount] Defconfig: ${DEFCONFIG}"

# 获取官方 dev 分支的集成脚本并执行
curl -fL --retry 3 \
  https://raw.githubusercontent.com/maxsteeel/nomount/dev/kernel/setup.sh \
  -o "${RUNNER_TEMP:-/tmp}/nomount-setup.sh"

cd "${KROOT}"
bash "${RUNNER_TEMP:-/tmp}/nomount-setup.sh" dev

# 启用内建 NoMount
if grep -q '^CONFIG_NOMOUNT=' "${DEFCONFIG}"; then
    sed -i 's/^CONFIG_NOMOUNT=.*/CONFIG_NOMOUNT=y/' "${DEFCONFIG}"
else
    echo 'CONFIG_NOMOUNT=y' >> "${DEFCONFIG}"
fi

echo "[NoMount] 集成脚本执行完毕，已请求启用 CONFIG_NOMOUNT=y"
