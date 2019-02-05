# bundler-audit

Patch-level verification for bundler.

## Features

* Checks for vulnerable versions of gems in `Gemfile.lock`.
* Checks for insecure gem sources (`http://`).
* Allows ignoring certain advisories that have been manually worked around.
* Prints advisory information.
* Does not require a network connection.

`bundle audit`


