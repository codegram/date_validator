# coding: utf-8
require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "date_validator"
    gem.summary = "A simple, ORM agnostic, Ruby 1.9 compatible date validator for Rails 3, based on ActiveModel."
    gem.description = "A simple, ORM agnostic, Ruby 1.9 compatible date validator for Rails 3, based on ActiveModel. Currently supporting :after, :before, :after_or_equal_to and :before_or_equal_to options."
    gem.email = "info@codegram.com"
    gem.homepage = "http://github.com/codegram/date_validator"
    gem.authors = ["Oriol Gual", "Josep M. Bach", "Josep Jaume Rey"]

    gem.add_dependency 'activemodel', '>= 3.0.0.rc'

    gem.add_development_dependency "rspec", '>= 2.0.0.beta.19'
    gem.add_development_dependency "activesupport", '>= 3.0.0.rc'
    gem.add_development_dependency "bundler", '>= 1.0.0.rc3'
    gem.add_development_dependency "tzinfo"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


# Rake RSpec2 task stuff
gem 'rspec', '>= 2.0.0.beta.19'
gem 'rspec-expectations'

require 'rspec/core/rake_task'

desc "Run the specs under spec"
RSpec::Core::RakeTask.new do |t|

end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end


  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "date_validator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
