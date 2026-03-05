class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.role = "user"
    @message.chat = @chat

    if @message.save
      @assistant_message = ask_llm(@chat, @message.content)

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

  def ask_llm(chat, user_message)
    system_prompt = 
    llm_chat = RubyLLM.chat
    llm_chat.with_instructions(system_prompt)
    response = llm_chat.ask(user_message).content
    chat.messages.create!(role: "assistant", content: response)
  end
end
