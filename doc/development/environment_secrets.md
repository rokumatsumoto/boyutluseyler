# Environment Secrets

| Credential name               | Credential value                        |
| ----------------------------- | --------------------------------------- |
| aws[region]                   | eu-central-1                            |
| aws[access_key_id]            | XXXXXXXXXXXXXXX                         |
| aws[secret_access_key]        | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    |
|                               |                                         |
| aws_s3[name]                  | s3                                      |
| aws_s3[bucket_name]           | your-bucket-name                        |
| aws_s3[processed_bucket_name] | your-processed-bucket-name              |
| aws_s3[access_key_id]         | XXXXXXXXXXXXXXX                         |
| aws_s3[secret_access_key]     | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    |
| aws_s3[region]                | eu-central-1                            |
| aws_s3[endpoint]              | XXXXXXXXXXXXXXX                         |
| aws_s3[processed_endpoint]    | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    |
| aws_s3[acl]                   | public-read                             |
| aws_s3[success_action_status] | '201'                                   |
|                               |                                         |
| facebook_key                  | XXXXXXXXXXXXXXX                         |
| facebook_secret               | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    |
|                               |                                         |
| google_key                    | XXXXXXXXXXXXXXX                         |
| google_secret                 | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    |
|                               |                                         |
| recaptcha_site_key            | XXXXXXXXXXXXXXX                         |
| recaptcha_secret_key          | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    |
|                               |                                         |
| redis[host]                   | localhost                               |
| redis[port]                   | 6379                                    |
| redis[url]                    | redis://your-redis-prod-url             |
|                               |                                         |
| rds_db_name                   | your-db-name                            |
| rds_username                  | your-db-username                        |
| rds_password                  | your-db-password                        |
| rds_hostname                  | your-db-hostname                        |
| rds_port                      | 5432                                    |
|                               |                                         |
| mail_sender                   | test@example.com                        |
| website                       | localhost:3000                          |
| cookie_domain                 | your-prod-domain                        |
|                               |                                         |
| send_grid_user_name           | your-sendgrid-username                  |
| send_grid_password            | your-sendgrid-password                  |
| send_grid_domain              | your-prod-domain                        |
| send_grid_host                | your-prod-host                          |
|                               |                                         |
| secret_key_base               | your-secret-key-base-generated-by-rails |

See [this](https://github.com/rokumatsumoto/boyutluseyler/pull/61) for cookie_domain
