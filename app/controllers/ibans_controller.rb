class IbansController < ApplicationController

before_action :set_user
before_action :find_iban, only: [:edit, :update]


def new
  @iban = Iban.new(account_id: @user.account.id)
  authorize @iban
end

def create
  @iban = Iban.new(iban_params)
    authorize @iban

    if @iban.save
      redirect_to profile_path
    else
      render :new
    end
end

def edit
  authorize @iban
end

def update
  authorize @iban

  if @iban.update(iban_params)
    redirect_to profile_path
  else
    render :edit
  end
end

private

 def set_user
    @user = User.find(params[:user_id])
  end

# def find_iban
#   @iban = Account.find(@user.iban.id)
# end

def iban_params
  params.require(:iban).permit(:account_id, :tag, :iban, :mangopay_id, :active)
end

def find_iban
  @iban = Iban.find(params[:id])
end

end
