module QueryReportFilterHelper
  def query_report_text_filter(name, value, options={})
    text_field_tag name, value, options
  end

  def query_report_date_filter(name, value, options={})
    text_field_tag name, value, options.merge(type: :date)
  end

  def query_report_boolean_filter(name, value, options={})
    concat(label_tag options[:placeholder])
    select_tag name, options_for_select([['', ''], ['true', 'true'], ['false', 'false']], value)
  end
end