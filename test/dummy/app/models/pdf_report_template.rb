class PdfReportTemplate < QueryReport::ReportPdf
  def render_header
    pdf.text "Test title", :size => 20, :style => :bold
    report.filters.each do |filter|
      filter.comparators.each do |comparator|
        pdf.text "#{comparator.name} : #{comparator.param_value}" if comparator.param_value.present?
      end
    end
    pdf.move_down 20
  end

  def render_footer
    pdf.move_down 20
    pdf.text "Copyright to @ashraf", :size => 12
  end

  def to_pdf
    render_header
    super
    render_footer
    pdf
  end

end