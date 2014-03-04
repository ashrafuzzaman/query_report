#!/usr/bin/env rake
# encoding: utf-8

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => "spec:all"

namespace :spec do
  desc "Run Tests against all ORMs"
  task :all do
    sh "bundle --quiet"
    sh "bundle exec rake spec"
  end
end

begin
  require 'rdoc/task'

  Rake::RDocTask.new do |rdoc|
    require 'kaminari/version'

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "query report #{QueryReport::VERSION}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
  puts 'RDocTask is not supported on this VM and platform combination.'
end