module QueryReportEngineLinkHelper
  def link_to_default_download_report_pdf
    if respond_to? :link_to_download_report_pdf
      link_to_download_report_pdf
    else
      link_to t('views.links.pdf'), export_report_url_with_format('pdf'), :target => "_blank"
    end
  end

  def link_to_default_download_report_csv
    if respond_to? :link_to_download_report_csv
      link_to_download_report_csv
    else
      link_to t('views.links.csv'), export_report_url_with_format('csv'), :target => "_blank"
    end
  end

  def link_to_default_email_query_report(target_dom_id)
    if respond_to? :link_to_email_query_report
      link_to_email_query_report(target_dom_id)
    else
      link_to t('views.labels.email'), 'javascript:void(0)', :onclick => "QueryReportEmail.openEmailModal('#{target_dom_id}');" if QueryReport.config.allow_email_report
    end
  end
end