module QueryReportFilterHelper
  def query_report_text_filter(name, value, options={})
    text_field_tag name, value, options
  end

  def query_report_date_filter(name, value, options={})
    text_field_tag name, value, options.merge(type: :date)
  end

  def link_to_download_report_pdf
    link_to t('views.links.pdf'), export_report_url_with_format('pdf'), :target => "_blank"
  end

  def link_to_download_report_csv
    link_to t('views.links.csv'), export_report_url_with_format('csv'), :target => "_blank"
  end
end