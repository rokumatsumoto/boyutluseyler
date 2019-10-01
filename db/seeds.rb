# This file should contain all the record creation needed to seed the database with its default
# values.
# The data can then be loaded with the rails db:seed command (or created alongside the database
#  with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Load seeds from YAML files in db/seeds/*

require 'seed_file'

SEED_DIR = 'db/seeds'

Dir[Rails.root.join("#{SEED_DIR}/*.yml")].each do |f|
  seed = SeedFile.new(f)
  puts "==> Seeding: #{seed.model.name}"
  print "  "
  seed.import! { |key| print "#{key} | " }
  print "\n"
end
