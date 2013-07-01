# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the helper module is to help controllers with the responders

require 'csv'
require 'query_report/report'
require 'query_report/report_pdf'

module QueryReport
  module Helper
    def reporter(query, options={}, &block)
      @report ||= QueryReport::Report.new(params, view_context, options)
      @report.query = query
      @report.instance_eval &block
      render_report
    end

    def render_report
      respond_to do |format|
        format.js { render 'query_report/list' }
        format.html { render 'query_report/list' }
        format.json { render json: @report.all_records }
        format.csv { send_data generate_csv_for_report(@report.all_records), :disposition => "attachment;" }
        format.pdf { send_data QueryReport::ReportPdf.new(@report).standard.render }
      end
    end

    def generate_csv_for_report(records)
      if records.size > 0
        columns = records.first.keys
        CSV.generate do |csv|
          csv << columns
          records.each do |record|
            csv << record.values.collect { |val| val.kind_of?(String) ? view_context.strip_links(val) : val }
          end
        end
      else
        nil
      end
    end
  end
end