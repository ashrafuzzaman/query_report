module QueryReport
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :pdf_options
    config_accessor :date_format
    config_accessor :datetime_format
    config_accessor :email_from
    config_accessor :allow_email_report
  end
end