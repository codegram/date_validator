module DateValidator
  class Engine < Rails::Engine
    initializer 'date_validator' do
      files = Dir[Pathname.new(File.dirname(__FILE__)).join('../..', 'locales', '*.yml')]
      config.i18n.load_path += files
    end
  end
end
