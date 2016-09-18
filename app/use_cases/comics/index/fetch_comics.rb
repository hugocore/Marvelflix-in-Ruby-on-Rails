module Comics
  module Index
    class FetchComics < UseCase::Base
      DEFAULT_ORDER_BY = '-onsaleDate'
      DEFAULT_PAGE_LIMIT = 20

      def perform
        api = Marvelite::API::Client.new(
          public_key: ENV['MARVEL_API_PUBLIC_KEY'],
          private_key: ENV['MARVEL_API_PRIVATE_KEY']
        )

        # REQ1: "I want to see a list of all Marvel’s released comic books covers ordered from
        # most recent to the oldest"
        comics_data = api.comics(
          orderBy: DEFAULT_ORDER_BY,
          offset: context.offset || 0,
          limit: context.limit || DEFAULT_PAGE_LIMIT
        )

        # Ruby's 2.3 dig method will return the value of the parameter ["data"]["results"] and it
        # will return nil if data or results are not present
        context.comics_data = comics_data.dig(:data, :results)
      end
    end
  end
end
