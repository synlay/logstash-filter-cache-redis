# Logstash Filter Redis Cache Plugin

[![Build Status](https://travis-ci.org/synlay/logstash-filter-cache-redis.svg)](https://travis-ci.org/synlay/logstash-filter-cache-redis)
[![Coverage Status](https://coveralls.io/repos/github/synlay/logstash-filter-cache-redis/badge.svg?branch=master)](https://coveralls.io/github/synlay/logstash-filter-cache-redis?branch=master)
[![Gem Version](https://badge.fury.io/rb/logstash-filter-cache-redis.svg)](https://badge.fury.io/rb/logstash-filter-cache-redis)
[![GitHub license](https://img.shields.io/github/license/synlay/logstash-filter-cache-redis.svg)](https://github.com/synlay/logstash-filter-cache-redis)

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is MIT, see [LICENSE](http://github.com/synlay/logstash-filter-cache-redis/LICENSE) for further infos.

## Documentation

This filter will store and retrieve data from Redis data cache. The fields `source` and `target` are used alternatively as data in- or output fields, while the value of a defined command like `rpush` will look for the corresponding event and use that value as the key. The following example for instance will store data from the event `ProductEntity` under the key based upon the data from the event `ProductId`:

```ruby
filter {
    cache_redis {
        rpush => "ProductId"
        source => "ProductEntity"
    }
}
```

## Developing

For further instructions on howto develop on logstash plugins, please see the documentation of the official [logstash-filter-example](https://github.com/logstash-plugins/logstash-filter-example#developing).
