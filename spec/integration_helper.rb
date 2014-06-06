require 'ransack/adapters/active_record' if defined?(::ActiveRecord::Base)
require 'query_report/report'
require 'query_report/report_pdf'
require 'fake_app/active_record/config'
require 'fake_app/active_record/models'

def reporter(query, params = {}, options = {}, &block)
  view_context = ApplicationController.helpers
  report = QueryReport::Report.new({}, view_context, options)
  report.query = query
  report.instance_eval &block
  report
end