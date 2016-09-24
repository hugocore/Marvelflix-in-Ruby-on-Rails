module Upvotes
  module Create
    class Persist < UseCase::Base
      def perform
        context.upvote = Upvote.find_or_create_by!(
          comic_id: context.comic_id,
          user: context.current_user
        )
      rescue
        context.errors = context.upvote.errors
      end
    end
  end
end
