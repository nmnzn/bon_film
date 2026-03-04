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
List.destroy_all
Movie.destroy_all
Link.destroy_all

User.find_or_create_by!(email: "test@test.com") do |u|
  u.first_name = "Jean"
  u.last_name  = "Dupont"
  u.password   = "password123"
end

puts "Seed OK user type : test@test.com / password123"

movie_1 = Movie.new(
  overview: "tres bon film",
  poster_path:"url",
  rate_average: 3.2,
  title: "mon film",
  tmdb_id: 1
)

movie_1.save

movie_2 = Movie.new(
  overview: "tres tres bon film",
  poster_path: "url",
  rate_average: 4.2,
  title: "the film",
  tmdb_id: 2
)

movie_2.save

puts "Seed OK list create"

list_1 = List.new(
  name: "Ma list",
  prompt: "film comique",
  user_id: 1
)
list_1.save

list_2 = List.new(
  name: "T'as list",
  prompt: "film comique",
  user_id: 1
)
list_2.save
  puts "Seed OK list create"

link_1 = Link.new(
  list_id: 1,
  movie_id: 2
)
link_1.save

link_2 = Link.new(
  list_id: 1,
  movie_id: 1
)
link_2.save

link_3 = Link.new(
  list_id: 2,
  movie_id: 2
)
link_3.save

puts "Seed OK link create"
