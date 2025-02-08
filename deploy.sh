#!/bin/bash

# アプリケーションを停止
systemctl stop vocaloid.app

# misskey ユーザーに切り替え
sudo su - misskey <<'EOF'
cd /home/misskey/misskey
git pull
NODE_ENV=production pnpm install --frozen-lockfile
NODE_ENV=production pnpm run build && pnpm run migrate
EOF

# root ユーザーに戻ってアプリケーションを再開
systemctl start vocaloid.app
