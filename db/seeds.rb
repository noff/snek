# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && !AdminUser.where(email: 'admin@example.com').exists?

# Create default arena

if Arena.where(id: 1).exists?
  Arena.find(1).update! name: 'Fort Square', area: Arena.default_arena
else
  Arena.create!(id: 1, name: 'Fort Square', area: Arena.default_arena)
end


if Arena.where(id: 2).exists?
  Arena.find(2).update! name: 'Fort Massacre', area: Arena.default_small_arena
else
  Arena.create!(id: 2, name: 'Fort Massacre', area: Arena.default_small_arena)
end

