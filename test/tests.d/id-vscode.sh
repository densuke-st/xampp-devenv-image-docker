#!/bin/sh
# ユーザーとしてvscodeで接続されていることを確認する
# UID=1000、GID=1000、sudo可能であることを確認する

if [ "$(id -u)" -ne 1000 ]; then
  echo "Error: User ID is not 1000. Current user ID is $(id -u)."
  exit 1
fi
if [ "$(id -g)" -ne 1000 ]; then
  echo "Error: Group ID is not 1000. Current group ID is $(id -g)."
  exit 1
fi
if ! sudo -l | grep -Eq "\(ALL(: ALL)?\) NOPASSWD: ALL"; then
  echo "Error: User $(id -un) is not in the sudoers file." >&2
  exit 1
fi
exit 0