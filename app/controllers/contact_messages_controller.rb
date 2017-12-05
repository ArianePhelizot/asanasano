class ContactMessagesController < ApplicationController
  helper ApplicationHelper
  skip_before_action :authenticate_user!

  def new
    @message = ContactMessage.new
    authorize @message
  end

  def create
    @message = ContactMessage.new(message_params)
    authorize @message
    if @message.valid?
      ContactMailer.contact_me(@message).deliver_now
      redirect_to new_contact_message_path, notice: "Message reçu, Merci! Nous revenons au plus vite vers vous. "
    else
      render :new
    end
  end

  def message_params
    params.require(:contact_message).permit(:name,
                                   :email,
                                   :company,
                                   :phone_number,
                                   :body)
  end
end
