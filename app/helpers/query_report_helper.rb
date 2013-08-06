require 'query_report/errors'

module QueryReportHelper
  def query_report_render_filter(filter, comparator)
    hint = comparator.name
    search_key = comparator.search_key
    search_tag_name = "#{filter.params_key}[#{search_key}]"
    value = params[filter.params_key] ? params[filter.params_key][comparator.search_key] : comparator.default

    if self.respond_to? :"query_report_#{filter.type.to_s}_filter"
      send :"query_report_#{filter.type.to_s}_filter", search_tag_name, value, :placeholder => hint
    else
      raise QueryReport::FilterNotDefined
    end
  end

  def export_report_url_with_format(format)
    url = request.url
    if url.match(/(\.\w*\?)/)
      url = url.gsub(/(\?)/, ".#{format}?")
    elsif url.match(/(\?)/)
      url = url.gsub(/(\?)/, ".#{format}?")
    else
      url = "#{url}.#{format}"
    end
    url.gsub(/format=(\w*)/, 'format=#{format}')
  end
end