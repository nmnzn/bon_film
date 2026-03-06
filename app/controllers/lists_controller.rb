class ListsController < ApplicationController
  require "json"
  require "open-uri"

  # index new create show destroy toggle_favorite
  def index
    @favorite_list_ids = current_user.favorites.pluck(:list_id)

    favorites = current_user.lists.where(id: @favorite_list_ids)
    others    = current_user.lists.where.not(id: @favorite_list_ids)

    @lists = favorites + others 
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id

    if @list.save
      Chat.create!(list: @list)

      prompt = @list.prompt
      @suggestions = movies_suggestion(prompt)
      movies_data = call_api(@suggestions)
      movies_create(movies_data)

      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @list = current_user.lists.find(params[:id])
    @chat = @list.chat
    @messages = @chat.messages.order(created_at: :asc) if @chat
    @is_favorite = current_user.favorites.exists?(list_id: @list.id)
  end

  def destroy
    @list = current_user.lists.find(params[:id])

    if @list.destroy
      redirect_to lists_path
    else
      redirect_to list_path(@list)
    end
  end

  def toggle_favorite
    @list = current_user.lists.find(params[:id])

    favorite = current_user.favorites.find_by(list_id: @list.id)

    if favorite
      favorite.destroy
      notice = "Retirée des favoris."
    else
      current_user.favorites.create!(list_id: @list.id)
      notice = "Ajoutée aux favoris."
    end

    redirect_back fallback_location: lists_path, notice: notice
  end

  private

  def list_params
    params.require(:list).permit(:name, :prompt, :user_id)
  end

  def movies_suggestion(prompt)
    system_prompt = "Tu es un spécialiste du cinéma (1910 à aujourd’hui) comme un curateur cinéma qui recommande des films simplement et naturellement. Ton ton : sympa, concis, utile. Pas de spoilers. Zéro blabla marketing.

    Ton objectif : proposer exactement 5 titres de films pertinents pour l’utilisateur, en te basant uniquement sur ce qui est explicitement présent dans la conversation : le nom de la liste, les films déjà présents dans cette liste, et éventuellement quelques messages récents.

    Méthode :
    1) Comprends l’intention : déduis les goûts probables à partir du nom de la liste + des films déjà présents + des messages récents.
    2) Évite les doublons : ne recommande jamais un film déjà dans la liste (même si l’orthographe ou l’année varie).
    3) Si les goûts sont flous : ne pose pas de questions, propose quand même 5 films cohérents avec le thème de la liste.
    4) Ne donne aucune explication, aucun tag, aucune année, aucune plateforme, aucune note, aucun réalisateur/casting. Uniquement des titres.

    Format de réponse (obligatoire, texte clair uniquement) :
    titre1, titre2, titre3, titre4, titre5"

    chat = RubyLLM.chat
    chat.with_instructions(system_prompt)
    chat.ask(prompt).content.split(", ")
  end

  def call_api(array_from_llm)
    array_of_hash = []
    tmdb_key = ENV.fetch("api_key", nil)

    array_from_llm.each do |movie|
      url = "https://api.themoviedb.org/3/search/movie?query=#{URI.encode_www_form_component(movie)}&api_key=#{tmdb_key}"
      movie_json = URI.parse(url).read
      movie_parsed = JSON.parse(movie_json)
      hash_clean = movie_parsed["results"].first
      array_of_hash.push(hash_clean) if hash_clean
    end

    array_of_hash
  end

  def movies_create(movies_data)
    movies_data.each do |data|
      movie = Movie.find_or_create_by(tmdb_id: data["id"]) do |value|
        value.title = data["title"]
        value.overview = data["overview"]
        value.poster_path = data["poster_path"]
        value.rate_average = data["vote_average"]
      end

      @list.movies << movie unless @list.movies.include?(movie)
    end
  end
end
