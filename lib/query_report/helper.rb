require 'query_report/report'

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
        format.json { render json: @report.records }
        format.csv { send_data generate_csv_for_report(@report.all_records), :disposition => "attachment;" }
        format.pdf { render_pdf(ReportPdf.new(@report).standard) }
      end
    end

    def generate_csv_for_report(records)
      if records.size > 0
        columns = records.first.keys
        CSV.generate do |csv|
          csv << columns
          records.each do |record|
            csv << record.values
          end
        end
      else
        nil
      end
    end
  end
end