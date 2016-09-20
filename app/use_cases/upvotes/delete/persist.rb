module Upvotes
  module Delete
    class Persist < UseCase::Base
      def perform
        context.upvote = Upvote.find_by(
          comic_id: context.comic_id,
          user: context.current_user
        ).destroy
      end
    end
  end
end
