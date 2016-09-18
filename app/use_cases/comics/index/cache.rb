require 'redis'
require 'json'

module Comics
  module Index
    class Cache
      def write(key, value, ttl = false)
        dump = value.to_json

        if ttl
          redis.setex(key.to_s, ttl, dump)
        else
          redis.set(key.to_s, dump)
        end
      end

      def read(key)
        dump = redis.get(key)

        return unless dump

        JSON.parse(dump)
      end

      def delete(key)
        redis.del(key)
      end

      alias del delete

      private

      def redis
        ::Redis.current
      end
    end
  end
end
