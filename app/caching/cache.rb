require 'redis'
require 'json'

# Class that caches data in redis as JSON
class Cache
  # According to http://developer.marvel.com/documentation/attribution we should cache data
  # for 24 hours by default
  DEFAULT_CACHE_TTL = 60 * 60 * 24 # 24 hours in seconds

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

  # This methods checks if there is a value cached according to a key, and returns it there is.
  # If there is no value cached using this key and if a block is passed, it saves the block's
  # return data and returns it, i.e. this method behaves just like ruby's "||=" operator. E.g.:
  #
  # > fetch('test')
  # => nil
  # > fetch('test') do
  #      'hello'
  #   end
  # => 'hello'
  # > fetch('test')
  # => 'hello'
  def fetch(key, ttl = DEFAULT_CACHE_TTL)
    cached_data = read(key)

    # If there is a cached_data cached, return that cached_data instead
    return cached_data if cached_data

    # If not, execute the block and cache the response data
    if block_given?
      cached_data = yield

      write(key, cached_data, ttl)
    end

    cached_data
  end

  private

  def redis
    ::Redis.current
  end
end
