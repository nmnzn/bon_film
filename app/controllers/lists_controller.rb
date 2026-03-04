class ListsController < ApplicationController
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
      movies_create(movies_data)
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
    chat.ask(prompt)
  end

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
  end
end
