module Upvotes
  module Delete
    class Base < UseCase::Base
      depends ParseParams,
              Persist

      def perform
        # logger.info "Remove upvote from ElasticSearch with: #{context.upvote}"
      end
    end
  end
end
