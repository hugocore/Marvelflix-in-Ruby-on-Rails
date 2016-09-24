class ComicsController < ApplicationController
  def index
    context = Comics::Index::Base.perform(
      offset: params[:offset],
      limit: params[:limit],
      current_user: current_user,
      characters: params[:characters]
    )

    @comics = context.comics
  end
end
