# Testing best practices

## Test speed

It's important that we make an effort to write tests that are accurate
and effective _as well as_ fast.

Here are some things to keep in mind regarding test performance:

- `double` and `spy` are faster than `FactoryBot.build(...)`
- `FactoryBot.build(...)` and `.build_stubbed` are faster than `.create`.
- Don't `create` an object when `build`, `build_stubbed`, `attributes_for`,
  `spy`, or `double` will do. Database persistence is slow!
- Don't mark a feature as requiring JavaScript (through `:js` in RSpec) unless it's _actually_ required for the test to be valid. Headless browser testing is slow!

#### SQL database

This is managed for us by the `database_cleaner` gem. Each spec is surrounded in
a transaction, which is rolled back once the test completes. Certain specs will
instead issue `DELETE FROM` queries against every table after completion; this
allows the created rows to be viewed from multiple database connections, which
is important for specs that run in a browser, or migration specs, among others.

One consequence of using these strategies, instead of the well-known
`TRUNCATE TABLES` approach, is that primary keys and other sequences are **not**
reset across specs. So if you create a project in spec A, then create a project
in spec B, the first will have `id=1`, while the second will have `id=2`.

This means that specs should **never** rely on the value of an ID, or any other
sequence-generated column. To avoid accidental conflicts, specs should also
avoid manually specifying any values in these kinds of columns. Instead, leave
them unspecified, and look up the value after the row is created.
