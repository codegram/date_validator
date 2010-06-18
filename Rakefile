require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "date_validator"
    gem.summary = "A simple date validator for Rails 3."
    gem.description = "A simple date validator for Rails 3. Currently supporting :after, :before, :after_or_equal_to and :before_or_equal_to options. Remarkable-friendly :)"
    gem.email = "info@codegram.com"
    gem.homepage = "http://github.com/codegram/date_validator"
    gem.authors = ["Oriol Gual", "Josep Mª Bach", "Josep Jaume Rey"]

    gem.add_dependency 'activemodel', '>= 3.0.0.beta4'

    gem.add_development_dependency "rspec", '>= 2.0.0.beta.12'
    gem.add_development_dependency "activesupport", '>= 3.0.0.beta4'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


# Rake RSpec2 task stuff
gem 'rspec', '>= 2.0.0.beta.12'
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
