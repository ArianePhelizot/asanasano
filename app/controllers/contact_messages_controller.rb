class ContactMessagesController < ApplicationController
  helper ApplicationHelper
  skip_before_action :authenticate_user!

  def new
    @message = if user_signed_in?
      ContactMessage.new(name: current_user.full_name,
                         phone_number: current_user.phone_number,
                         email: current_user.email)
    else
      ContactMessage.new
    end

    authorize @message
  end

  def create
    @message = ContactMessage.new(message_params)
    authorize @message
    if @message.valid?
      ContactMailer.contact_me(@message).deliver_now
      flash[:notice] = "Message reçu, Merci! Nous revenons au plus vite vers vous. "
      redirect_to new_contact_message_path
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
