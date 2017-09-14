## 0.3.2
 - Introduce redis command `sismember`

## 0.3.1
 - Prevent infinite loops for retries after errors or failed lock acquisitions
 - Introduce optional configuration options for controlling the count and
   the interval of retries - see :max_retries, :lock_retry_interval and
   :max_lock_retries

## 0.3.0
 - Support for GET, SET, EXISTS, DEL, SADD, SMEMBERS and SCARD
 - Introduce new control field `cmd_key_is_formatted` for declaring commands
   to be resolved through - see %{foo} handling

## 0.2.0
 - Support for HSET and HGET

## 0.1.0
 - Initial version; simple caching with redis
