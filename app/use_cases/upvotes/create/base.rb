module Upvotes
  module Create
    class Base < UseCase::Base
      depends ParseParams,
              Persist

      def perform
        # logger.info "Send upvote to ElasticSearch with: #{context.upvote}"
      end
    end
  end
end
