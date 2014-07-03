require 'query_report/errors'

module QueryReportEngineHelper
  def query_report_render_filter(filter, comparator)
    hint = comparator.name
    search_tag_name = comparator.search_tag_name
    value = comparator.param_value

    method_name = :"query_report_#{filter.type.to_s}_filter"
    default_method_name = :"query_report_default_#{filter.type.to_s}_filter"
    if respond_to? method_name
      send method_name, search_tag_name, value, :placeholder => hint
    elsif respond_to? default_method_name
      send default_method_name, search_tag_name, value, :placeholder => hint
    else
      raise QueryReport::FilterNotDefined, %Q{#{filter.type.to_s} filter is not defined.
        Please define a method as following,
        def #{method_name}(name, value, options={})
          text_field_tag name, value, options
        end
      }
    end
  end

  def render_query_report(report = nil)
    report ||= @report
    render :partial => "query_report/list", locals: {report: report}
  end

  def export_report_url_with_format(format)
    url_for(params.merge(format: format))
  end
end