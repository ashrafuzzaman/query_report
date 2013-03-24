require "query_report/version"
require "query_report/record"

module QueryReport
  autoload :VERSION,                  'query_report/version'
  autoload :Helper,                   'query_report/helper'
  autoload :Views,                    'query_report/views'
  autoload :Record,                   'query_report/record'
  autoload :PieChart,                 'query_report/chart/pie_chart'
end