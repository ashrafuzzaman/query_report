require "query_report/engine"

module QueryReport
  mattr_accessor :pdf_options
  self.pdf_options = {
      color: '000000',
      font_size: 12,
      table: {
          row: {odd_bg_color: "DDDDDD", even_bg_color: "FFFFFF"},
          header: {bg_color: 'AAAAAA', font_size: 12}
      }
  }
end