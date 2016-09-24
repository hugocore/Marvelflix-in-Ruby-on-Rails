module Comics
  module Index
    class FetchComics < UseCase::Base
      DEFAULT_ORDER_BY = '-onsaleDate'.freeze
      DEFAULT_PAGE_LIMIT = 20
      DEFAULT_COMIC_FORMAT = 'comic'
      DEFAULT_CACHE_KEY = 'marvel_request:%s'.freeze

      def perform
        context.comics_data = cache.fetch(cache_key) do
          fetch_comics_from_marvel
        end
      end

      private

      def cache
        @cache ||= Cache.new
      end

      def cache_key
        format(DEFAULT_CACHE_KEY, Digest::SHA1.hexdigest("#{Date.today}#{context_params}"))
      end

      def fetch_comics_from_marvel
        api = Marvelite::API::Client.new(
          public_key: ENV['MARVEL_API_PUBLIC_KEY'],
          private_key: ENV['MARVEL_API_PRIVATE_KEY']
        )

        # REQ1: "I want to see a list of all Marvel's released comic books covers ordered from
        # most recent to the oldest"
        comics_data = api.comics(context_params)

        # Ruby's 2.3 dig method will return the value of the parameter ["data"]["results"] and it
        # will return nil if "data" or "results" are not present
        comics_data.dig(:data, :results)
      end

      def context_params
        @_context ||= begin
          {
            format: DEFAULT_COMIC_FORMAT,
            orderBy: DEFAULT_ORDER_BY,
            offset: context.offset || 0,
            limit: context.limit || DEFAULT_PAGE_LIMIT,
          }
        end

        # REQ3: "I want to be able to search by character (ex. deadpool) so that I can find my
        # favorite comics"
        @_context.merge!(characters: context.character) if context.character.present?

        @_context
      end
    end
  end
end
