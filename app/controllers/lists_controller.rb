class ListsController < ApplicationController
  # index new create show destroy
  def index
  @lists = current_user.lists
  end
end
