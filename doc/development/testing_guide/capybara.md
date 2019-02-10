## Capybara

Use `js: true` to switch to the `Capybara.javascript_driver` (`:selenium` by default)

`feature` is in fact just an alias for `describe ..., type: :feature`

`background` is an alias for `before`

`scenario` for `it`

`given/given!` aliases for `let/let!` respectively.

#### `Capybara.default_driver`

If you are using RSpec or Cucumber, you may instead want to consider leaving the faster :rack_test as the

default_driver, and marking only those tests that require a JavaScript-capable driver using `js: true` or

`@javascript`, respectively. By default, JavaScript tests are run using the `:selenium` driver. You can

change this by setting

`Capybara.javascript_driver = :chrome`

#### Rubocop Cops

https://rubocop-rspec.readthedocs.io/en/latest/cops_capybara/

#### Performance tweak

https://relishapp.com/rspec/rspec-rails/v/3-0/docs/upgrade

