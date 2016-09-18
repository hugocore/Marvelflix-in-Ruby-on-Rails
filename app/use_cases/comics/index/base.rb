module Comics
  module Index
    class Base < UseCase::Base
      depends FetchComics

      # Maps cached or new comics data into a collection of Comics
      def perform
        context.comics = context.comics_data.map { |comic| OpenStruct.new(comic) }
      end
    end
  end
end
