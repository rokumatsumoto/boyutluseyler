## Pundit

####  Generator

Use the supplied generator to generate policies:

``` sh
rails g pundit:policy post
```

#### Manually retrieving policies and scopes

Sometimes you want to retrieve a policy for a record outside the controller or view. For example when you delegate permissions from one policy to another.

You can easily retrieve policies and scopes like this:

``` ruby
Pundit.policy!(user, post)
Pundit.policy(user, post)

Pundit.policy_scope!(user, Post)
Pundit.policy_scope(user, Post)
```

The bang methods will raise an exception if the policy does not exist, whereas those without the bang will return nil.


#### Testing

Testing Pundit Policies with RSpec

https://www.thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec/
