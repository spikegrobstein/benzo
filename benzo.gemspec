# -*- encoding: utf-8 -*-
require File.expand_path('../lib/benzo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Spike Grobstein"]
  gem.email         = ["me@spike.cx"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "benzo"
  gem.require_paths = ["lib"]
  gem.version       = Benzo::VERSION

  gem.add_dependency 'cocaine'
end
