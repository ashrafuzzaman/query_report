module QueryReport
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :pdf_options
    config_accessor :date_format
    config_accessor :datetime_format
  end
end