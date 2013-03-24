require 'query_report/record'

module QueryReport
  module Helper
    def reporter(query, &block)
      @record ||= QueryReport::Record.new(params)
      @record.set_query(query)
      @record.instance_eval &block
      render_report
    end

    def render_report
      respond_to do |format|
        format.html { render 'query_report/list' }
        format.json { render json: @record.records }
        format.csv { send_data generate_csv_for_report(@record.all_records), :disposition => "attachment;" }
        format.pdf { render_pdf(ReportPdf.new.list(@record.all_records)) }
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