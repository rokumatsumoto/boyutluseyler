## Simple Form with Bootstrap

Inside your views, use the `simple_form_for` with the Bootstrap form class, `'.form-inline'`, as the following:

`= simple_form_for(@user, html: { class: 'form-inline' }) do |form|`

#### Live example app

http://simple-form-bootstrap.plataformatec.com.br/

https://github.com/rafaelfranca/simple_form-bootstrap

#### Required

By default all inputs are required. When the form object includes ActiveModel::Validations (which, for
example, happens with Active Record models), fields are required only when there is presence validation.
Otherwise, Simple Form will mark fields as optional. For performance reasons, this detection is skipped
on validations that make use of conditional options, such as :if and :unless.

#### Available input types and defaults for each column type

The following table shows the html element you will get for each attribute
according to its database definition. These defaults can be changed by
specifying the helper method in the column `Mapping` as the `as:` option.

Mapping         | Generated HTML Element               | Database Column Type
--------------- |--------------------------------------|---------------------
`boolean`       | `input[type=checkbox]`               | `boolean`
`string`        | `input[type=text]`                   | `string`
`citext`        | `input[type=text]`                   | `citext`
`email`         | `input[type=email]`                  | `string` with `name =~ /email/`
`url`           | `input[type=url]`                    | `string` with `name =~ /url/`
`tel`           | `input[type=tel]`                    | `string` with `name =~ /phone/`
`password`      | `input[type=password]`               | `string` with `name =~ /password/`
`search`        | `input[type=search]`                 | -
`uuid`          | `input[type=text]`                   | `uuid`
`text`          | `textarea`                           | `text`
`hstore`        | `textarea`                           | `hstore`
`json`          | `textarea`                           | `json`
`jsonb`         | `textarea`                           | `jsonb`
`file`          | `input[type=file]`                   | `string` responding to file methods
`hidden`        | `input[type=hidden]`                 | -
`integer`       | `input[type=number]`                 | `integer`
`float`         | `input[type=number]`                 | `float`
`decimal`       | `input[type=number]`                 | `decimal`
`range`         | `input[type=range]`                  | -
`datetime`      | `datetime select`                    | `datetime/timestamp`
`date`          | `date select`                        | `date`
`time`          | `time select`                        | `time`
`select`        | `select`                             | `belongs_to`/`has_many`/`has_and_belongs_to_many` associations
`radio_buttons` | collection of `input[type=radio]`    | `belongs_to` associations
`check_boxes`   | collection of `input[type=checkbox]` | `has_many`/`has_and_belongs_to_many` associations
`country`       | `select` (countries as options)      | `string` with `name =~ /country/`
`time_zone`     | `select` (timezones as options)      | `string` with `name =~ /time_zone/`

