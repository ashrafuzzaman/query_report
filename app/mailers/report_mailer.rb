class ReportMailer < ActionMailer::Base
  default from: QueryReport.config.email_from

  def send_report(user, to, subject, message, file_name, attachment)
    @user = user
    @message = message
    attachments["#{file_name}.pdf"] = attachment
    mail(:to => to, :subject => subject)
  end
end