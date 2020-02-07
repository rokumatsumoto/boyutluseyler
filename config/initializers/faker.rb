if Rails.env.development? || Rails.env.test?
  Faker::Config.locale = 'en'
end
