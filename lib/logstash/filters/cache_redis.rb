# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "redis"

class LogStash::Filters::CacheRedis < LogStash::Filters::Base
    config_name "cache_redis"

    # The field to perform filter
    #
    config :source, :validate => :string, :default => "message"

    # The name of the container to put the result
    #
    config :target, :validate => :string, :default => "message"

    # The hostname(s) of your Redis server(s). Ports may be specified on any
    # hostname, which will override the global port config.
    # If the hosts list is an array, Logstash will pick one random host to connect to,
    # if that host is disconnected it will then pick another.
    #
    # For example:
    # [source,ruby]
    #     "127.0.0.1"
    #     ["127.0.0.1", "127.0.0.2"]
    #     ["127.0.0.1:6380", "127.0.0.1"]
    config :host, :validate => :array, :default => ["127.0.0.1"]

    # Shuffle the host list during Logstash startup.
    config :shuffle_hosts, :validate => :boolean, :default => true

    # The default port to connect on. Can be overridden on any hostname.
    config :port, :validate => :number, :default => 6379

    # The Redis database number.
    config :db, :validate => :number, :default => 0

    # Redis initial connection timeout in seconds.
    config :timeout, :validate => :number, :default => 5

    # Password to authenticate with.  There is no authentication by default.
    config :password, :validate => :password

    # Interval for reconnecting to failed Redis connections
    config :reconnect_interval, :validate => :number, :default => 1

    # # Sets the action. If set to true, it will get the data from redis cache
    # config :get, :validate => :boolean, :default => false
    config :llen, :validate => :string

    # # Sets the action. If set to true, it will get the data from redis cache
    # config :get, :validate => :boolean, :default => false
    config :rpush, :validate => :string

    # # Sets the action. If set to true, it will get the data from redis cache
    # config :get, :validate => :boolean, :default => false
    config :rpush_if_not_exists, :validate => :string

    # # Sets the action. If set to true, it will get the data from redis cache
    # config :get, :validate => :boolean, :default => false
    config :rpop, :validate => :string

    # # Sets the action. If set to true, it will get the data from redis cache
    # config :get, :validate => :boolean, :default => false
    config :lpop, :validate => :string

    # # Sets the action. If set to true, it will get the data from redis cache
    # config :get, :validate => :boolean, :default => false
    # O(N)
    config :lget, :validate => :string


    public
    def register
        @redis = nil
        if @shuffle_hosts
            @host.shuffle!
        end
        @host_idx = 0
    end # def register


    def filter(event)

        # TODO: Maybe refactor the interface into a more flexible one with two
        #       main configs 'cmd' & 'args'. Then it would be possible to eliminate
        #       all if clauses and replace it through one hashmap call, where
        #       the hashmap would be a mapping from 'cmd' -> <cmd_function_ref>
        #       E.q.: cmds.fetch(event.get(@llen), &method(:cmd_not_found_err))

        begin
            @redis ||= connect

            if @llen
                event.set(@target, @redis.llen(event.get(@llen)))
            end

            if @rpush
                @redis.rpush(event.get(@rpush), event.get(@source))
            end

            if @rpush_if_not_exists
                @redis.multi do |multi|
                    key = event.get(@rpush_if_not_exists)
                    unless multi.exists(key)
                        multi.rpush(key, event.get(@source))
                    end
                end
            end

            if @rpop
                event.set(@target, @redis.rpop(event.get(@rpop)))
            end

            if @lget
                event.set(@target, @redis.lrange(event.get(@lget), 0, -1))
            end

        rescue => e
            @logger.warn("Failed to send event to Redis", :event => event,
                         :identity => identity, :exception => e,
                         :backtrace => e.backtrace)
            sleep @reconnect_interval
            @redis = nil
            retry
        end

        # filter_matched should go in the last line of our successful code
        filter_matched(event)
    end # def filter


    private
    def connect
        @current_host, @current_port = @host[@host_idx].split(':')
        @host_idx = @host_idx + 1 >= @host.length ? 0 : @host_idx + 1

        if not @current_port
            @current_port = @port
        end

        params = {
            :host => @current_host,
            :port => @current_port,
            :timeout => @timeout,
            :db => @db
        }
        @logger.debug("connection params", params)

        if @password
            params[:password] = @password.value
        end

        Redis.new(params)
    end # def connect

end # class LogStash::Filters::Example
