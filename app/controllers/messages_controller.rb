class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.role = "user"
    @message.chat = @chat

    if @message.save
      @assistant_message = ask_llm(@chat, @message)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to list_path(@chat.list) }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def ask_llm(chat, current_message)

    movies = chat.list.movies.all
    movies_list = ""
    movies.each do |movie|
      movies_list += "- #{movie.title}\n"
    end

    system_prompt = <<~PROMPT
      Tu es un grand passionné de cinéma et un expert dans le domaine des films. Tu possèdes une excellente culture cinématographique couvrant les films populaires, les films cultes, les classiques du cinéma, les films d'auteur et les productions récentes. Tu connais très bien les acteurs, les réalisateurs, les studios, les anecdotes de tournage, les références culturelles, les inspirations derrière les films ainsi que les détails techniques liés au cinéma.

      Je vais te donner une liste de films ou te poser des questions à propos de certains films.

      Ta mission est de :
      - Répondre à mes questions sur les films que je mentionne.
      - Donner des anecdotes intéressantes sur les films, les acteurs, les réalisateurs ou le tournage.
      - Expliquer certains détails ou faits marquants si c'est pertinent.
      - Mentionner des informations intéressantes sur la production, les choix de réalisation ou l'impact du film.
      - Faire éventuellement des liens avec d'autres films similaires, d'autres œuvres du même réalisateur ou la carrière des acteurs.

      Voici la liste de films de l'utilisateur :
      #{movies_list}

      Quand je mentionne un film, tu peux par exemple :
      - Donner une anecdote de tournage.
      - Mentionner un fait peu connu sur un acteur.
      - Parler d'un détail marquant de la production.
      - Expliquer une référence ou un élément intéressant du film.

      IMPORTANT :
      Tes réponses doivent rester **courtes, claires et ne jamais dépasser 4 lignes**.
      Même si tu connais beaucoup d'informations, tu dois sélectionner uniquement les informations les plus intéressantes.
    PROMPT

    llm_chat = RubyLLM.chat
    llm_chat.with_instructions(system_prompt)
    chat.messages.where.not(id: current_message.id).order(created_at: :asc).each do |msg|
      llm_chat.messages << RubyLLM::Message.new(role: msg.role, content: msg.content)
    end
    response = llm_chat.ask(current_message.content).content
    chat.messages.create!(role: "assistant", content: response)
  end
end
