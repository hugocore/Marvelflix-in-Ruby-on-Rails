module Characters
  module Index
    class FetchCharacters < UseCase::Base
      def perform
        context.characters = Character.where("name LIKE '%#{context.query}%'")
      end
    end
  end
end
