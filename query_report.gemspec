$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "query_report/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "query_report"
  s.version = QueryReport::VERSION
  s.author = "A.K.M. Ashrafuzzaman"
  s.email = ["ashrafuzzaman.g2@gmail.com"]
  s.description = %q{This is a gem to help you to structure common reports of you application just by writing in the controller}
  s.summary = %q{Structure you reports}
  s.homepage = "http://ashrafuzzaman.github.io/query_report"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.license = 'MIT'
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'railties', ['>= 3', '< 5']
  s.add_dependency 'ransack', '~> 1.0'
  s.add_dependency 'google_visualr', '~> 2'
  s.add_dependency 'rmagick', '~> 2.13'
  s.add_dependency 'gruff', '~> 0.5'
  s.add_dependency 'kaminari', '~> 0.16'
  s.add_dependency 'prawn', '~> 1.0.0'
  s.add_dependency 'chartify', '~> 0.2.1'

  s.add_development_dependency 'rake', ['~> 10.3']
  s.add_development_dependency 'rspec', ['~> 3']
  # s.add_development_dependency 'rspec-core', ['~> 3']
  s.add_development_dependency 'rspec-mocks', '~> 3'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'database_cleaner', ['~> 1.2']
end