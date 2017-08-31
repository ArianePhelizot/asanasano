class IbansController < ApplicationController
  before_action :set_user
  before_action :find_iban, only: [:edit, :update]

  def new
    @iban = Iban.new(account_id: @user.account.id)
    authorize @iban
  end

  # rubocop:disable Metrics/MethodLength
  def create
    @iban = Iban.new(iban_params)
    authorize @iban

    if @iban.save

      # créer l'IBAN chez Mangopay
      mangopay_iban_bankaccount = MangoPay::BankAccount.create(
        @user.account.mangopay_id, mangopay_iban_info
      )

      # updater l'IBAN avec les données de MangoPay
      @iban.mangopay_id = mangopay_iban_bankaccount["Id"]
      @iban.active = mangopay_iban_bankaccount["Active"]
      @iban.save

      redirect_to profile_path
    else
      render :new
    end
  end

  # rubocop:enable Metrics/MethodLength
  def edit
    authorize @iban
  end

  # rubocop:disable Metrics/MethodLength
  def update
    authorize @iban

    if @iban.update(iban_params)
      mangopay_iban_bankaccount = MangoPay::BankAccount.create(
        @user.account.mangopay_id, mangopay_iban_info
      )
      @iban.active = mangopay_iban_bankaccount["Active"]
      @iban.save
      redirect_to profile_path
    else
      render :edit
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def find_iban
    @iban = Account.find(current_user.iban.id)
  end

  def iban_params
    params.require(:iban).permit(:account_id, :tag, :iban, :mangopay_id, :active)
  end

  def mangopay_iban_info
    { Type: "IBAN",
      OwnerName: [@user.first_name, @user.last_name].join(" "),
      OwnerAddress: @user.account.address,
      IBAN: @user.account.iban.iban,
      Tag: "Bank account of #{@user.account.iban.tag}" }
  end
end
