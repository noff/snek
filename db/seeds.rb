# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && !AdminUser.where(email: 'admin@example.com').exists?


default_arena = [
    %w(wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty empty wall),
    %w(wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall wall)
]
Arena.find_or_create_by(id: 1, name: 'Fort Square', area: default_arena)