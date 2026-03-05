# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Message.destroy_all
Chat.destroy_all
Link.destroy_all
List.destroy_all
Movie.destroy_all
# On garde l'user existant
User.where.not(email: "test@test.com").destroy_all

user = User.find_or_create_by!(email: "test@test.com") do |u|
  u.first_name = "Jean"
  u.last_name  = "Dupont"
  u.password   = "password123"
end

puts "Seed OK - user: test@test.com / password123"

# Movies réalistes avec de vrais tmdb_id
movies = [
  { title: "Inception",          tmdb_id: 27205, overview: "Un voleur qui s'infiltre dans les rêves des autres se voit offrir une chance de rédemption.", poster_path: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg", rate_average: 8.4 },
  { title: "The Dark Knight",    tmdb_id: 155,   overview: "Batman affronte le Joker, un criminel anarchiste qui plonge Gotham dans le chaos.", poster_path: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg", rate_average: 9.0 },
  { title: "Parasite",           tmdb_id: 496243, overview: "Toute la famille Ki-taek est au chômage. Ils s'infiltrent peu à peu dans la vie d'une famille riche.", poster_path: "/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg", rate_average: 8.5 },
  { title: "Interstellar",       tmdb_id: 157336, overview: "Un groupe d'explorateurs utilise un tunnel de ver pour voyager au-delà des limites connues de l'espace.", poster_path: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg", rate_average: 8.6 },
  { title: "The Grand Budapest Hotel", tmdb_id: 120467, overview: "Les aventures du légendaire concierge d'un grand hôtel européen entre les deux guerres mondiales.", poster_path: "/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg", rate_average: 8.1 },
  { title: "Pulp Fiction",       tmdb_id: 680,   overview: "Los Angeles. Deux tueurs à gages, un boxeur, un gangster et sa femme se retrouvent mêlés à des situations absurdes.", poster_path: "/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg", rate_average: 8.9 },
]

created_movies = movies.map { |attrs| Movie.create!(attrs) }
puts "Seed OK - #{created_movies.count} films créés"

# Listes avec associations par objet (pas par id hardcodé)
list_action = List.create!(name: "Thrillers & Action", prompt: "films de thriller et action cultes", user: user)
list_art    = List.create!(name: "Cinéma d'auteur",    prompt: "films d'auteur primés",              user: user)

# Links
inception, dark_knight, parasite, interstellar, grand_budapest, pulp_fiction = created_movies

Link.create!(list: list_action, movie: inception)
Link.create!(list: list_action, movie: dark_knight)
Link.create!(list: list_action, movie: interstellar)
Link.create!(list: list_action, movie: pulp_fiction)

Link.create!(list: list_art, movie: parasite)
Link.create!(list: list_art, movie: grand_budapest)
Link.create!(list: list_art, movie: inception)

puts "Seed OK - listes et liens créés"

# Chat avec quelques messages pour list_action
chat = Chat.create!(list: list_action)
Message.create!(chat: chat, role: "user",      content: "Suggère-moi un film d'action haletant pour ce soir.")
Message.create!(chat: chat, role: "assistant", content: "Je te recommande Inception ! Un thriller de Christopher Nolan avec des rebondissements incroyables. Note : 8.4/10.")

puts "Seed OK - chat et messages créés"
puts "\nConnexion : test@test.com / password123"
 .!
