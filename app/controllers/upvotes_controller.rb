class UpvotesController < AuthenticatedController
  def create
    @context = Upvotes::Create::Base.perform(current_user: current_user, comic_id: params[:comic_id])

    respond
  end

  def delete
    @context = Upvotes::Delete::Base.perform(current_user: current_user, comic_id: params[:comic_id])

    respond
  end

  private

  def respond
    if @context.success?
      redirect_to root_path
    else
      redirect_to root_path, notice: @context.errors
    end
  end
end
