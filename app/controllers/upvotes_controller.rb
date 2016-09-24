class UpvotesController < AuthenticatedController
  def create
    @context = Upvotes::Create::Base.perform(current_user: current_user, comic_id: params[:comic_id])

    redirect_to_root
  end

  def delete
    @context = Upvotes::Delete::Base.perform(current_user: current_user, comic_id: params[:comic_id])

    redirect_to_root
  end

  private

  def redirect_to_root
    if @context.success?
      redirect_to root_path
    else
      redirect_to root_path, notice: @context.errors
    end
  end
end
