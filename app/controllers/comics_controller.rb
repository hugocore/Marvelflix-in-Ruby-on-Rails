class ComicsController < ApplicationController
  def index
    context = Comics::Index::Base.perform(
      offset: params[:offset],
      limit: params[:limit],
      current_user: current_user,
      character: params[:character]
    )

    @comics = context.comics
  end
end
