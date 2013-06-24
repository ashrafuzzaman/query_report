require 'query_report/errors'

module QueryReportHelper
  def query_report_render_filter(filter, key, hint)
    search_key = "#{filter.column}_#{key}"
    search_tag_name = filter.custom? ? "custom_search[#{search_key}]" : "q[#{search_key}]"
    value = (filter.custom? ? params[:custom_search][search_key] : params[:q][search_key]) rescue ''
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