#!/bin/bash

# misskey ユーザーに切り替え
sudo su - misskey <<'EOF'
cd /home/misskey/misskey
git fetch origin

# 現在のハッシュとリリースブランチのハッシュを比較
CURRENT_HASH=$(git rev-parse HEAD)
RELEASE_HASH=$(git rev-parse origin/release)

if [ "$CURRENT_HASH" == "$RELEASE_HASH" ]; then
    echo "No updates found in the release branch."
    exit 1
fi

if [ -z "$RELEASE_HASH" ]; then
    echo "Release branch does not exist."
    exit 1
fi

echo "Updates found in the release branch."
exit 0
EOF
