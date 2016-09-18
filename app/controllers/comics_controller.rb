class ComicsController < ApplicationController
  def index
    context = Comics::Index::Base.perform(offset: params[:offset], limit: params[:limit])

    @comics = context.comics
  end
end
