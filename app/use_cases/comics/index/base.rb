module Comics
  module Index
    class Base < UseCase::Base
      # depends ...

      def perform
        api = Marvelite::API::Client.new(
          public_key: ENV['MARVEL_API_PUBLIC_KEY'],
          private_key: ENV['MARVEL_API_PRIVATE_KEY']
        )

        context.comics = api.comics(orderBy: 'onsaleDate')["data"]["results"]
      end
    end
  end
end
