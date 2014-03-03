class @QueryReport
  @sendEmail: (email_to, subject, message) =>
    searchForm = $("div.query_report:visible form")
    searchForm.find("#send_as_email").val(1)
    searchForm.find("#email_to").val(email_to)
    searchForm.find("#subject").val(subject)
    searchForm.find("#message").val(message)
    searchForm.submit()