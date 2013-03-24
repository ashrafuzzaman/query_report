# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'query_report/version'

Gem::Specification.new do |gem|
  gem.name          = "query_report"
  gem.version       = QueryReport::VERSION
  gem.authors       = ["A.K.M. Ashrafuzzaman"]
  gem.email         = ["ashrafuzzaman.g2@gmail.com"]
  gem.description   = %q{This is a gem to help you to structure common reports of you application just by writing in the controller}
  gem.summary       = %q{Structure you reports}
  gem.homepage      = "https://github.com/ashrafuzzaman/query_report"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "app"]

  gem.add_dependency 'ransack'
  gem.add_dependency 'google_visualr', '>= 2.1'
end
