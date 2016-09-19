module Comics
  module Index
    class Base < UseCase::Base
      depends FetchComics,
              FetchUserUpvotes

      # Maps cached or new comics data into a collection of Comics
      def perform
        context.comics = context.comics_data.map do |comic|
          Comic.new(comic.merge(upvote: map_comic_upvote(comic['id'])))
        end
      end

      private

      # From the set of upvotes for the current user, check if any of those is related with the
      # comic that we are iterating in this class
      def map_comic_upvote(comic_id)
        context.upvotes.select { |upvote| upvote.comic_id == comic_id }
      end
    end
  end
end
