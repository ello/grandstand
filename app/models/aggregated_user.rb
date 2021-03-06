# frozen_string_literal: true

class AggregatedUser

  class << self
    def add(id, username)
      redis.hset(key, username, id)
      new(id, username)
    end

    def all
      redis.hgetall(key).map do |resp|
        new(resp[1].to_i, resp[0])
      end
    end

    def get(username)
      return unless (id = redis.hget(key, username))

      new(id.to_i, username)
    end

    def remove(username)
      redis.hdel(key, username)
    end

    def clear
      redis.del(key)
    end

    private

    def redis
      Redis.current
    end

    def key
      "#{Rails.env}:aggregated_users"
    end
  end

  attr_accessor :id, :username

  def initialize(id, username)
    @id = id
    @username = username
  end
end
