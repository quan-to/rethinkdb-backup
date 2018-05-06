RethinkDB Rancher Backup
=========================

Docker image to make RethinkDB Backups in Rancher using `socialengine/rancher-cron`

Usage
========

Makes a backup from specified rethinkdb (runs rethinkdb-dump) into s3 at `s3://${BUCKET_NAME}/${ENV_NAME}/${STACK_NAME}/` when it starts.

Environment variables:

- *ENV_NAME* - Overrides Environment Name (Default: from rancher metadata)
- *STACK_NAME* - Overrides Stack Name (Default: from rancher metadata)
- *RETHINK_HOST* - RethinkDB Hostname to backup. (Default: `db`)
- *RETHINK_PORT* - RethinkDB Port (Default: `28015`)
- *BUCKET_NAME* - S3 Bucket Name to store. (Default: `backup`)
- *NOTIFY_SLACK* - If this container should notify it's status in slack
- *SLACK_URL* - Slack Incoming Webhook URL
- *SLACK_CHANNEL* - Slack Channel to post (Default: `#general`)
- *SLACK_USERNAME* - Slack Username (Default: `RethinkDB - ${ENV_NAME}`)
- *SLACK_ICONEMOJI* - Slack Icon Emoji (Default: `:minidisc:`)

Secrets:
- *AWS_ACCESS_KEY* - Access Key to AWS S3
- *AWS_ACCESS_SECRET* - Access Secret to AWS S3

Ideally it should run with `socialengine/rancher-cron`:

```yaml
  rethinkdb-backup:
    image: quantocommons/rethinkdb-backup
    environment:
      BUCKET_NAME: my-backup
      RETHINK_HOST: rethinkdb.mystack
      RETHINK_PORT: '28015'
    stdin_open: true
    tty: true
    secrets:
    - mode: '0444'
      uid: '0'
      gid: '0'
      source: aws_coldstorage_key
      target: AWS_ACCESS_KEY
    - mode: '0444'
      uid: '0'
      gid: '0'
      source: aws_coldstorage_sec
      target: AWS_ACCESS_SECRET
    labels:
      io.rancher.container.start_once: 'true'
      io.rancher.container.pull_image: always
      com.socialengine.rancher-cron.schedule: '@daily'
```