# Profiling

To make it easier to track down performance problems boyutluseyler comes with a set of
profiling tools, some of these are available by default while others need to be
explicitly enabled.

## Bullet

Bullet is a Gem that can be used to track down N+1 query problems. Because
Bullet adds quite a bit of logging noise it's disabled by default. To enable
Bullet, set the environment variable `ENABLE_BULLET` to a non-empty value before
starting boyutluseyler. For example:

    ENABLE_BULLET=true bundle exec rails s

Bullet will log query problems to both the Rails log as well as the Chrome
console.
