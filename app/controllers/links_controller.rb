class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list

  def destroy
    link = @list.links.find(params[:id])
    link.destroy

    redirect_to list_path(@list), notice: "Film retiré de la liste."
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end
end

# méthod destroy crud


# rails routes -g links
