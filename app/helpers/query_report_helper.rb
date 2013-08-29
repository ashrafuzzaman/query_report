require 'query_report/errors'

module QueryReportHelper
  def query_report_render_filter(filter, comparator)
    hint = comparator.name
    search_tag_name = comparator.search_tag_name
    value = comparator.param_value

    method_name = :"query_report_#{filter.type.to_s}_filter"
    if main_app.respond_to? method_name
      main_app.send method_name, search_tag_name, value, :placeholder => hint
    elsif self.respond_to? method_name
      self.send method_name, search_tag_name, value, :placeholder => hint
    else
      raise QueryReport::FilterNotDefined, "#{filter.type.to_s} filter is not defined"
    end
  end

  def export_report_url_with_format(format)
    url_for(params.merge(format: format))
  end
end