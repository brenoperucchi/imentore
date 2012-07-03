module Imentore
  class FeedbacksController < BaseController

    def create
      if params[:store_id]
        feedback = current_store.feedbacks.new(params[:feedback])
        feedback.store = current_store
        if feedback.save
          Imentore::SendEmailMailer.send_mail_mailer(feedback.email, current_store.email_contact, feedback.subject, feedback.question).deliver
          redirect_to root_path
        end
      else
        current_store.products.find(params[:product_id]).feedback.create(params[:feedback])
      end
    end

  end
end
