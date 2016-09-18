class ComicsController < ApplicationController
  def index
    context = Comics::Index::Base.perform()

    @comics = context.comics
  end
end
