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

### Table-based / Parameterized tests

This style of testing is used to exercise one piece of code with a comprehensive
range of inputs. By specifying the test case once, alongside a table of inputs
and the expected output for each, your tests can be made easier to read and more
compact.

We use the [rspec-parameterized](https://github.com/tomykaira/rspec-parameterized)
gem. A short example, using the table syntax and checking Ruby equality for a
range of inputs, might look like this:

```ruby
describe "#==" do
  using RSpec::Parameterized::TableSyntax

  let(:project1) { create(:project) }
  let(:project2) { create(:project) }
  where(:a, :b, :result) do
    1         | 1        | true
    1         | 2        | false
    true      | true     | true
    true      | false    | false
    project1  | project1 | true
    project2  | project2 | true
    project 1 | project2 | false
  end

  with_them do
    it { expect(a == b).to eq(result) }

    it 'is isomorphic' do
      expect(b == a).to eq(result)
    end
  end
end
```
