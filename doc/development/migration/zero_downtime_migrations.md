## Zero Downtime Migrations

https://jacopretorius.net/2017/05/zero-downtime-migrations-in-rails.html

https://dev.to/mscccc/high-traffic-app-that-cant-take-downtime---data-migration-450d

https://pedro.herokuapp.com/past/2011/7/13/rails_migrations_with_no_downtime/

https://www.braintreepayments.com/blog/safe-operations-for-high-volume-postgresql/

You can test that your migration is reversible by running

`rake db:migrate:redo`

We use Strong Migrations gem for catching unsafe migrations at dev time

