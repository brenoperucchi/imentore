module Imentore
  class SendEmailMailer < ActionMailer::Base
    # default from: "from@example.com"
    default :content_type => "text/html"

    def notice_imentore(store)
      mail(from: 'atendimento@imentore.com.br', to: 'atendimento@imentore.com.br', subject: "Store Criado: #{store.url}") do |format|
        format.html {render text: "Criado"}
      end
    end

    def create_store(to, store, password)
      @store = store
      @password = password
      subject = "Dados de Login Imentore - #{store.name}"
      mail(from: 'atendimento@imentore.com.br', to: to, subject: subject)
    end


    def send_mail_mailer(from, to, subject, body)
      mail(from: from, to: to, subject: subject) do |format|
        format.html {render :text => body}
      end
    end
  end
end