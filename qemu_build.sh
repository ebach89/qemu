#!/usr/bin/env sh

## https://stackoverflow.com/questions/32435138/what-is-the-difference-and-relationship-between-xx-softmmu-and-xx-linux-user
## arch-softmmu - will compile 'qemu-system-arch' binary for full system emulation (including peripheral)
## arch-linux-user  - will compile 'qemu-arch' for user-Mode emulation, i.e. when cross-compiled binary is run under Qemu
##                     starting from crt::start.c::_start()

## script params
# $1 - Emulation mode: 'user' of 'system'

set -e
set -x

SCRIPT_NAME="$0"
EMUL_MODE="$1"

emul_mode_target=
build_dir="./build"
extra_flags=
target_install_path="/home/ebach89/Work/bins/qemu/arm64/"
target_install_name=
src_install_name=

script_usage() {
  echo "$SCRIPT_NAME #1"
  echo "    where:"
  echo "        #1 - Emulation mode: 'user'|'system'"
}

set_emul_mode_target() {
  case "$1" in
  "user")
      emul_mode_target="linux-user"
      extra_flags="--static"
      target_install_name="qemu-aarch64-static_v5_0"
      src_install_name="${build_dir}/aarch64-${emul_mode_target}/qemu-aarch64"
      return 0
      ;;
  "system")
      emul_mode_target="softmmu"
      target_install_name="qemu-system-aarch64_v5_0"
      src_install_name="${build_dir}/aarch64-${emul_mode_target}/qemu-system-aarch64"
      return 0
      ;;
  *)
      echo "error: emulation mode target: '$1' is not supported"
      return 1
      ;;
  esac
}

if  ! set_emul_mode_target "$EMUL_MODE"; then
  echo "ERROR: wrong params for script '$SCRIPT_NAME'"
  script_usage
  exit 1
fi

if [ ! -d "$build_dir" ]; then
  mkdir "$build_dir"
fi
cd "$build_dir"
../configure --target-list=aarch64-${emul_mode_target} "$extra_flags"
make -j$(nproc)

cd -

if [ -f "$src_install_name" ]; then
  echo "Installing... '$src_install_name' to '${target_install_path}/$target_install_name'"
  cp -v "$src_install_name" "${target_install_path}/$target_install_name"
fi
