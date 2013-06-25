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
        color: '000000',
        font_size: 12,
        table: {
            row: {odd_bg_color: "DDDDDD", even_bg_color: "FFFFFF"},
            header: {bg_color: 'AAAAAA', font_size: 12}
        }
    }
  end
end