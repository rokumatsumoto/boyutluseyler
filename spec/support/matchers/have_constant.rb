# rubocop:disable Metrics/BlockLength
RSpec::Matchers.define :have_constant do |const, klass|
  match do |owner|
    return owner.const_defined?(const) if klass.nil?
    return owner.const_defined?(const) && owner.const_get(const).class == klass if @value.nil?

    owner.const_defined?(const) && owner.const_get(const).class == klass &&
      owner.const_get(const) == @value
  end

  chain :with_value do |value|
    @value = value
  end

  failure_message do |actual|
    msg = +"constant #{const} not defined in #{actual}"
    msg += " as a #{klass}" unless klass.nil?
    msg += " with value #{@value}" unless @value.nil?
    msg
  end

  failure_message_when_negated do |actual|
    msg = +"constant #{const} is defined in #{actual}"
    msg += " as a #{klass}" unless klass.nil?
    msg += " with value #{@value}" unless @value.nil?
    msg
  end

  description do
    msg = +"have constant #{const}"
    msg += " defined with class #{klass}" unless klass.nil?
    msg += " and value #{@value}" unless @value.nil?
    msg
  end
end
# rubocop:enable Metrics/BlockLength

RSpec::Matchers.alias_matcher :define_constant, :have_constant
