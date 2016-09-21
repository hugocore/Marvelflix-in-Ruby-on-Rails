module Comics
  module Index
    class FetchUserUpvotes < UseCase::Base
      # Preload all the upvotes from the current user for the current set of comics, to avoid
      # N+1 queries when we are mapping upvotes against comics
      def perform
        return unless context.current_user

        context.upvotes = Upvote.where(
          comic_id: context.comics_data.map { |comic| comic['id'] },
          user: context.current_user
        )
      end
    end
  end
end
