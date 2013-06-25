module QueryReport
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :pdf_options
  end
end