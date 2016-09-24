module Characters
  module Index
    class Base < UseCase::Base
      depends FetchCharacters

      def perform
        # Log which characters were searched to record metrics and produce stats, using Elastic
        # Search + Kibana, for instance.
        # logger.info "Found these characters #{context.characters.map(&:name)}"
      end
    end
  end
end
