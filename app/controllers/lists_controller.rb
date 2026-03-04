class ListsController < ApplicationController
    # index new create show destroy
    def index
    # @lists = current_user.lists
    end
    def new
      @list = List.new
    end

    def create
      list = List.new(list_params)
      list.user_id = current_user.id
      if list.save
        redirect_to list_path(list)
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
    def list_params
      params.require(:list).permit(:name, :prompt, :user_id)
    end
end
