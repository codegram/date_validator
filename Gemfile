source "https://rubygems.org"

gemspec

active_model_opts =
  case ENV['ACTIVE_MODEL_VERSION']
  when 'master' then { github: 'rails/rails' }
  when 'default' then '~> 3'
  else "~> #{ENV['ACTIVE_MODEL_VERSION']}"
  end

gem 'activemodel', active_model_opts

platforms :rbx do
  gem 'rubysl', '~> 2.0'
end
