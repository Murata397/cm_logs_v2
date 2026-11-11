class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "CM Logs <no-reply@cm-logs.example>")
  layout "mailer"
end
