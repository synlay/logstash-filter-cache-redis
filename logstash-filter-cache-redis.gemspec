Gem::Specification.new do |s|
  s.name = 'logstash-filter-cache-redis'
  s.version         = '0.1.0'
  s.licenses        = ['MIT']
  s.summary         = "Logstash filter for decoding (X)HTML entities from event fields"
  s.description     = "A Logstash filter plugin for decoding (X)HTML entities from event fields. This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gem_name. This gem is not a stand-alone program."
  s.authors         = ["David Robakowski"]
  s.email           = 'david.robakowski@synlay.com'
  s.homepage        = "https://github.com/synlay/logstash-filter-cache-redis"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency 'redis', '~> 3.3', '>= 3.3.3'
  s.add_development_dependency 'logstash-devutils'
end
