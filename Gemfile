source "http://rubygems.org"

gemspec

active_model_version = ENV['ACTIVE_MODEL_VERSION'] || 'default'

active_model_opts =
  case active_model_version
  when 'master'
    { github: 'rails/rails' }
  when 'default'
    '~> 3'
  else
    "~> #{active_model_version}"
  end

gem 'activemodel', active_model_opts

platforms :rbx do
  gem 'rubysl', '~> 2.0'
end
