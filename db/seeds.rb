# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all

User.find_or_create_by!(email: "test@test.com") do |u|
  u.first_name = "Jean"
  u.last_name  = "Dupont"
  u.password   = "password123"
end

puts "Seed OK user type : test@test.com / password123"
