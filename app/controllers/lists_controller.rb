class ListsController < ApplicationController
  require "json"
  require "open-uri"

  # index new create show destroy
  def index
   @lists = current_user.lists
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id
    if @list.save
      prompt = @list.prompt
      @suggestions = movies_suggestion(prompt)
<<<<<<< HEAD
      movies_create(movies_data)
=======
      array_for_api = call_api(@suggestions)
      raise ## suite pour Neil afin de créer 5 instances de Movies à associer à la @list à partir de cet array de 5 hash (chaque hash égal un movie)
      #   @list.save
>>>>>>> origin
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def list_params
    params.require(:list).permit(:name, :prompt, :user_id)
  end

  def movies_suggestion(prompt)
    system_prompt = "Tu es un spécialiste du cinéma (1910 à aujourd’hui) comme un curateur cinéma qui recommande des films simplement et naturellement. Ton ton : sympa, concis, utile. Pas de spoilers. Zéro blabla marketing.

    Ton objectif : proposer exactement 5 titres de films pertinents pour l’utilisateur, en te basant uniquement sur ce qui est explicitement présent dans la conversation : le nom de la liste, les films déjà dedans, et éventuellement quelques messages récents.

    Méthode :
    1) Comprends l’intention : déduis les goûts probables à partir du nom de la liste + des films déjà présents + des messages récents.
    2) Évite les doublons : ne recommande jamais un film déjà dans la liste (même si l’orthographe ou l’année varie).
    3) Si les goûts sont flous : ne pose pas de questions, propose quand même 5 films cohérents avec le thème de la liste.
    4) Ne donne aucune explication, aucun tag, aucune année, aucune plateforme, aucune note, aucun réalisateur/casting. Uniquement des titres.

    Format de réponse (obligatoire, texte clair uniquement) :
    titre1, titre2, titre3, titre4, titre5"

    chat = RubyLLM.chat
    chat.with_instructions(system_prompt)
<<<<<<< HEAD
    chat.ask(prompt).content.split(", ")
  end

  def call_api(array_from_llm)
    array_of_hash = []
    array_from_llm.each do |movie|
      url = "https://api.themoviedb.org/3/search/movie?query=#{movie}&api_key=26306aac9a2af9029b1001967bb0b129"
      movie = URI.parse(url).read
      movie_parsed = JSON.parse(movie)
      hash_clean = movie_parsed["results"].first
      array_of_hash.push(hash_clean)
    end
    return array_of_hash
  end

  def index
    @lists = current_user.lists
=======
    chat.ask(prompt)
  end

<<<<<<< HEAD
  def movies_create(movies_data)
    movies_data.each do |data|
      movie = Movie.find_or_create_by(tmdb_id: data[:id]) do |value|
        value.title = data[:title]
        value.overview = data[:overview]
        value.poster_path = data[:poster_path]
        value.rate_average = data[:rate_average]
      end
      @list.movies << movie
    end
=======
>>>>>>> master
>>>>>>> origin
  end
end
