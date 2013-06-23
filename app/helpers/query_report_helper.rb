module QueryReportHelper
  def query_report_text_filter(name, value, options={})
    text_field_tag name, value, options
  end

  def query_report_date_filter(name, value, options={})
    text_field_tag name, value, options.merge(type: :date)
  end
end