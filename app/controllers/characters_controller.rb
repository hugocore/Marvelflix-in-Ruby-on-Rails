class CharactersController < ApplicationController
  def index
    context = Characters::Index::Base.perform(query: params[:query])

    @characters = context.characters
  end
end
