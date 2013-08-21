class PdfReportTemplate
  def initialize(report, pdf)
    @report, @pdf = report, pdf
  end

  def render_header
    @pdf.text "Test title", :size => 20, :style => :bold
  end

  def render_footer
    @pdf.text "Copyright to @ashraf", :size => 12
  end
end