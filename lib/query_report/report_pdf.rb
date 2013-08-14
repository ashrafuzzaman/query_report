module QueryReport
  class ReportPdf
    attr_reader :pdf, :options, :report

    def initialize(report)
      @report = report
      @options = QueryReport.config.pdf_options
      @pdf = Prawn::Document.new
    end

    def render_header()
    end

    def pdf_content(&code)
      render_header
      code.call(pdf)
      pdf
    end

    def standard
      pdf_content do
        render_charts_with @report
        render_table_with @report
      end
    end

    private
    def render_charts_with(report)
      return if report.charts.empty? #or !report.chart_on_pdf?
      report.charts.each do |chart|
        if chart.respond_to?(:to_blob)
          blob = chart.to_blob
          data = StringIO.new(blob)
          pdf.pad_top(10) do
            pdf.image(data, :width => 200)
          end
        end
      end
    end

    def table_header_for(table_items)
      table_items.first.keys
    end

    def humanized_table_header_for(report)
      report_columns.collect(&:humanize)
    end

    def table_content_for(report)
      table_items = report.all_records
      table_items.map do |item|
        item_values = []

        report_columns.collect(&:humanize).each do |column|
          item_values << item[column].to_s
        end
        item_values
      end
    end

    def render_table_with(report)
      items = [humanized_table_header_for(report)]
      items += table_content_for(report)
      render_table(items)
    end

    def render_table(items)
      header_bg_color = @options[:table][:header][:bg_color]
      alternate_row_bg_color = [@options[:table][:row][:odd_bg_color], @options[:table][:row][:even_bg_color]]
      font_size = @options[:font_size]
      header_font_size = @options[:table][:header][:font_size]
      pdf.move_down 10
      pdf.table(items, :row_colors => alternate_row_bg_color, :header => true, :cell_style => {:inline_format => true, :size => font_size}) do
        row(0).style(:font_style => :bold, :background_color => header_bg_color, :size => header_font_size)
      end
    end

    private
    def report_columns
      report.columns.select { |c| c.options[:only_on_web] != true }
    end
  end
end