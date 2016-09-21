module Upvotes
  module Delete
    class ParseParams < UseCase::Base
      def perform
        unless context.current_user
          failure(:user, 'cannot be empty when removing the upvote of a comic')
        end

        unless context.comic_id
          failure(:comic_id, 'cannot be empty when upvoting a comic')
        end
      end
    end
  end
end
