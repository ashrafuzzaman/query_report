require "query_report/engine"

module QueryReport
  autoload :Configuration, "query_report/config"

  def self.configure(&block)
    yield @config ||= QueryReport::Configuration.new
  end

  def self.config
    @config
  end

  configure do |config|
    config.pdf_options = {
        template_class: nil,
        color: '000000',
        font_size: 12,
        table: {
            row: {odd_bg_color: "DDDDDD", even_bg_color: "FFFFFF"},
            header: {bg_color: 'AAAAAA', font_size: 12}
        },
        chart: { height: 160, width: 200 }
    }
    config.date_format = :default
    config.datetime_format = :default
  end
end