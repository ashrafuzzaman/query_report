require "prawn"
require "open-uri"

class ReportPdf
  attr_accessor :pdf, :default_options

  def initialize(report)
    @report = report
    self.default_options = {alternate_row_bg_color: ["DDDDDD", "FFFFFF"],
                            header_bg_color: 'AAAAAA',
                            color: '000000',
                            light_color: '555555'}
    self.pdf = Prawn::Document.new
  end

  def render_header(options={})
    #pdf.font("Times-Roman", size: 10) do
    #  pdf.text_box current_institute.address.to_s,
    #               :at => [400, pdf.cursor+20],
    #               :inline_format => true,
    #               :height => 100,
    #               :width => 100
    #end
  end

  def pdf_content(&code)
    render_header
    code.call(pdf)
    pdf
  end

  def standard
    pdf_content do
      render_charts_with @report
      render_table_with(@report.all_records, {font_size: 8, header_font_size: 10})
    end
  end

  private
  def render_charts_with(report)
    return if report.charts.nil? or !report.chart_on_pdf?
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

  def table_header_for(table_items, options={})
    table_items.first.keys
  end

  def humanized_table_header_for(table_items, options={})
    table_items.first.keys.collect(&:humanize) rescue table_header_for(table_items, options)
  end

  def table_content_for(table_items, options)
    table_items.map do |item|
      item_values = []

      options[:table_header].each do |header|
        item_values << cell_for(item, header)
      end
      item_values
    end
  end

  def cell_for(item, prop)
    val = item.respond_to?(prop) ? item.send(prop) : item[prop]
    if val.kind_of? Array
      val.collect { |v| [v] }
      return pdf.make_table(val)
    end
    val
  end

  def render_table_with(table_items, options={})
    if table_items.present?
      options[:table_header] ||= table_header_for(table_items, options)
      items = [humanized_table_header_for(table_items)]
      items += table_content_for(table_items, options)
      items += table_footer_for(table_items, options)
      options[:bold_footer] = options[:titles_of_column_to_sum].present?
      render_table(items, options)
    end
    pdf
  end

  def render_table(items, options={})
    options = default_options.merge options
    header_bg_color = options[:header_bg_color]
    pdf.move_down 10
    pdf.table(items, :row_colors => options[:alternate_row_bg_color], :header => true, :cell_style => {:inline_format => true, :size => options[:font_size] || 10}) do
      row(0).style(:font_style => :bold, :background_color => header_bg_color, :size => options[:header_font_size] || 14)
      row(items.size-1).style(:font_style => :bold) if options[:bold_footer]
    end
  end

  def table_footer_for(table_items, options)
    return [] if options[:titles_of_column_to_sum].blank?
    total_hash = {} #for calculating total for a column
    options[:titles_of_column_to_sum].each do |col|
      total_hash[col] = table_items.sum { |i| (i.respond_to?(col) ? i.send(col) : i[col]) || 0 }
    end

    render_footer_with_col_span(total_hash, options)
  end

end