require "query_report/version"
require "query_report/record"
require 'query_report/chart/pie_chart'
require 'query_report/chart/custom_chart'

module QueryReport
  autoload :VERSION,                  'query_report/version'
  autoload :Helper,                   'query_report/helper'
  autoload :Views,                    'query_report/views'
  autoload :Record,                   'query_report/record'
  autoload :Filter,                   'query_report/filter'
  autoload :Column,                   'query_report/column'
end