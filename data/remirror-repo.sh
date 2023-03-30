#!/bin/bash
set -e
D="$(mktemp -d)"

cd "$D"

export GIT_SSH_COMMAND="ssh -i ~/.ssh/gitee"
git clone --bare git@gitee.com:kprokopenko/bachelor-thesis-info.git
cd bachelor-thesis-info.git
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519"
git push --mirror git@github.com:kp2pml30/bachelor-thesis-info-mirror.git

cd ~
rm -rf "$D"
