# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless User.any?
  password = SecureRandom.alphanumeric(16)
  email = 'test@clortho.dev'
  if User.create(email: email, password: password)
    puts "Created first user '#{email}' with password '#{password}'"
  end
end