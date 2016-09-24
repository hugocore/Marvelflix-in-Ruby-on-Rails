module Upvotes
  module Delete
    class Persist < UseCase::Base
      def perform
        context.upvote = Upvote.find_by(
          comic_id: context.comic_id,
          user: context.current_user
        )

        context.upvote&.destroy!
      rescue
        context.errors = context.upvote.errors
      end
    end
  end
end
