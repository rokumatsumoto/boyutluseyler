## Hamlit

#### How to know if you are using hamlit

In Rails

`ActionView::Template.handler_for_extension("haml")`

`=> #<Hamlit::RailsTemplate:0x005593caad2150>`

In Sinatra, or any Tilt environment

`Tilt["haml"]`

`=> Hamlit::Template`

Or in all environments, you can try to render incompatibility

input

`%div{ foo: false }`

output in Haml

`<div></div>`

output in Hamlit

`<div foo=''></div>`

#### Refs

https://github.com/k0kubun/hamlit/issues/108
