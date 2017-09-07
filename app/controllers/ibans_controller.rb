class IbansController < ApplicationController
  before_action :set_user
  before_action :find_iban, only: [:edit, :update]

  def new
    @iban = Iban.new(account_id: @user.account.id)
    authorize @iban
  end

  # rubocop:disable Metrics/MethodLength
  def create

    log_error = nil

    @iban = Iban.new(iban_params)
    authorize @iban

    if @iban.save
      begin
        # créer l'IBAN chez Mangopay
        mangopay_iban_bankaccount = MangoPay::BankAccount.create(
          @user.account.mangopay_id, mangopay_iban_info
        )

        # updater l'IBAN avec les données de MangoPay
        @iban.mangopay_id = mangopay_iban_bankaccount["Id"]
        @iban.active = mangopay_iban_bankaccount["Active"]
        @iban.save

      rescue MangoPay::ResponseError => ex
        log_error = ex.message
      rescue => ex
        log_error = ex.message
      ensure
         MangopayLog.create(event: "iban_creation",
                            mangopay_answer: mangopay_iban_bankaccount,
                            user_id: @user.id.to_i,
                            error_logs: log_error)
      end
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

    log_error = nil

    authorize @iban

    if @iban.update(iban_params)

      begin
        mangopay_iban_bankaccount = MangoPay::BankAccount.create(
          @user.account.mangopay_id, mangopay_iban_info
        )
        @iban.active = mangopay_iban_bankaccount["Active"]
        @iban.save

      rescue MangoPay::ResponseError => ex
          log_error = ex.message
      rescue => ex
          log_error = ex.message
      ensure
        MangopayLog.create(event: "iban_creation",
                              mangopay_answer: mangopay_iban_bankaccount,
                              user_id: @user.id.to_i,
                              error_logs: log_error)
        redirect_to profile_path
      end
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
    @iban = Iban.find(params[:id])
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
