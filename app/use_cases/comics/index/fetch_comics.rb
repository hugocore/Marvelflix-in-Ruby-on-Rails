module Comics
  module Index
    class FetchComics < UseCase::Base
      DEFAULT_ORDER_BY = '-onsaleDate'.freeze
      DEFAULT_PAGE_LIMIT = 20
      DEFAULT_COMIC_FORMAT = 'comic'

      # According to http://developer.marvel.com/documentation/attribution we should cache data
      # only for 24 hours
      DEFAULT_CACHE_TTL = 60 * 60 * 24 # 24 hours in seconds
      DEFAULT_CACHE_KEY = 'marvel_request:%s'.freeze

      def perform
        context.comics_data = fetch_and_cache(cache_key) do
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

      # This methods checks if there is a value cached according to a key, and returns it there is.
      # If there is no value cached using this key and if a block is passed, it saves the block's
      # return data and returns it, i.e. this method behaves just like ruby's "||=" operator. E.g.:
      #
      # > fetch_and_cache('test')
      # => nil
      # > fetch_and_cache('test') do
      #      'hello'
      #   end
      # => 'hello'
      # > fetch_and_cache('test')
      # => 'hello'
      def fetch_and_cache(key)
        comics_data = cache.read(key)

        # If there is a comics_data cached, return that comics_data instead
        return comics_data if comics_data

        # If not, execute the block and cache the response data
        if block_given?
          comics_data = yield

          cache.write(key, comics_data, DEFAULT_CACHE_TTL)
        end

        comics_data
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
        # will return nil if data or results are not present
        comics_data.dig(:data, :results)
      end

      def context_params
        @_context ||= begin
          {
            format: DEFAULT_COMIC_FORMAT,
            orderBy: DEFAULT_ORDER_BY,
            offset: context.offset || 0,
            limit: context.limit || DEFAULT_PAGE_LIMIT
          }
        end
      end
    end
  end
end
