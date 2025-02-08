# v.deploy

このリポジトリには、Misskeyのデプロイを自動化するためのスクリプトが含まれています。

## ファイル構成

- `main.sh`: デプロイのメインスクリプト。`check.sh` を実行し、成功した場合に `deploy.sh` を実行します。
- `check.sh`: Misskeyのリリースブランチをチェックし、更新があるかどうかを確認します。
- `deploy.sh`: Misskeyの更新作業を行います。
- `config.json`: MisskeyおよびDiscordのWebHook設定を含む設定ファイル。

## 設定

`config.json` ファイルに以下の設定を追加してください。

```json
{
    "misskeyApiToken": "YOUR_MISSKEY_API_TOKEN",
    "misskeyUrl": "https://misskey.example.com",
    "discordWebhookUrl": "https://discord.com/api/webhook"
}
```

## 使用方法

1. `main.sh` を実行します。これは通常、cronジョブとして設定されます。
2. `main.sh` は `check.sh` を実行し、リリースブランチに更新があるかどうかを確認します。
3. 更新がある場合、MisskeyおよびDiscordに通知を送信し、30秒後に `deploy.sh` を実行します。
4. `deploy.sh` はMisskeyの更新作業を行い、完了後に再度通知を送信します。

## cronジョブの設定例

以下は、毎時0分に `main.sh` を実行するcronジョブの設定例です。

```bash
0 * * * * /mnt/v.deploy/main.sh
```
