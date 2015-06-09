module DateValidator
  class Engine < Rails::Engine
    files = Dir[Pathname.new(File.dirname(__FILE__)).join('../..', 'locales', '*.yml')]
    config.i18n.load_path += files
  end
end
