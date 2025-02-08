#!/bin/bash

# スクリプトのディレクトリに移動
cd "$(dirname "$0")"

# config.json を読み込む
CONFIG_FILE="./config.json"
MISSKEY_API_TOKEN=$(jq -r '.misskeyApiToken' $CONFIG_FILE)
MISSKEY_URL=$(jq -r '.misskeyUrl' $CONFIG_FILE)
DISCORD_WEBHOOK_URL=$(jq -r '.discordWebhookUrl' $CONFIG_FILE)

# WebHook通知関数
send_discord_webhook() {
    local url=$1
    local message=$2
    curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" $url
}

send_misskey_api() {
    local url="$MISSKEY_URL/api/notes/create"
    local message=$1
    curl -X POST -H "Content-Type: application/json" -d "{\"i\": \"$MISSKEY_API_TOKEN\", \"text\": \"$message\"}" $url
}

echo "Starting check process..."

# check.sh を実行
./check.sh

# check.sh が成功した場合に deploy.sh を実行
if [ $? -eq 0 ]; then
    CURRENT_HASH=$(sudo su - misskey -c "cd /home/misskey/misskey && git rev-parse HEAD")
    RELEASE_HASH=$(sudo su - misskey -c "cd /home/misskey/misskey && git rev-parse origin/release")
    
    MESSAGE="Misskey Miry Remixに更新がありました\n現在のハッシュ: $CURRENT_HASH\n更新後のハッシュ: $RELEASE_HASH\n30秒後に更新しますね！"
    send_misskey_api "$MESSAGE"
    send_discord_webhook $DISCORD_WEBHOOK_URL "$MESSAGE"
    
    sleep 30
    
    echo "Check passed. Starting deployment..."
    ./deploy.sh
    if [ $? -eq 0 ]; then
        MESSAGE="Misskey Miry Remix の更新が完了しました！\n更新前のハッシュ: $CURRENT_HASH\n更新後のハッシュ: $RELEASE_HASH\n引き続き、ぼかろすきーをお楽しみください！"
        send_misskey_api "$MESSAGE"
        send_discord_webhook $DISCORD_WEBHOOK_URL "$MESSAGE"
        echo "Deployment completed successfully."
    else
        echo "Deployment failed."
    fi
else
    echo "Check failed. Deployment aborted."
fi
