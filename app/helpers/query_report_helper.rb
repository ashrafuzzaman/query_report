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

  def query_report_text_filter(name, value, options={})
    text_field_tag name, value, options
  end

  def query_report_date_filter(name, value, options={})
    text_field_tag name, value, options.merge(type: :date)
  end

  def link_to_download_report_pdf
    link_to_format 'pdf'
  end

  def link_to_download_report_csv
    link_to_format 'csv'
  end

  def link_to_format(format)
    url = request.url
    if url.match(/(\.\w*\?)/)
      url = url.gsub(/(\?)/, ".#{format}?")
    elsif url.match(/(\?)/)
      url = url.gsub(/(\?)/, ".#{format}?")
    else
      url = "#{url}.#{format}"
    end
    url = url.gsub(/format=(\w*)/, 'format=#{format}')
    link_to t("views.labels.#{format}"), url, :target => "_blank"

  end

end