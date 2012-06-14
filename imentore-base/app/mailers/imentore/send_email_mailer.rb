module Imentore
  class SendEmailMailer < ActionMailer::Base
    # default from: "from@example.com"
    default :content_type => "text/html"


    def send_mail_mailer(from, to, subject, body)
      mail(from: from, to: to, subject: subject) do |format|
        format.html {render :text => body}
      end
    end
  end
end