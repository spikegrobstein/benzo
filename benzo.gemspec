# -*- encoding: utf-8 -*-
require File.expand_path('../lib/benzo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Spike Grobstein"]
  gem.email         = ["me@spike.cx"]
  gem.description   = %q{Take the edge off when doing (command) lines.}
  gem.summary       = %q{A robust mapper for complex commandline calls using cocaine.}
  gem.homepage      = "https://github.com/spikegrobstein/benzo"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "benzo"
  gem.require_paths = ["lib"]
  gem.version       = Benzo::VERSION

  gem.add_dependency 'cocaine', "~> 0.5.8"
end
