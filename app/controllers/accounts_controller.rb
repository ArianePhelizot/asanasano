# rubocop:disable Metrics/ClassLength
class AccountsController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  before_action :set_user
  before_action :find_account, only: [:edit, :update]
  before_action :set_log_error, only: [:create,
                                       :mangopay_create_natural_user,
                                       :mangopay_create_legal_user,
                                       :mangopay_update_natural_user,
                                       :mangopay_update_legal_user]

  def new
    @account = Account.new(user_id: @user.id)
    authorize @account
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @account = Account.new(account_params)
    authorize @account

    if @account.save
      if @account.person_type == "NATURAL"
        mangopay_create_natural_user(@account.id)
      else
        mangopay_create_legal_user(@account.id)
      end

      begin
        # Local wallet creation
        @wallet = Wallet.create(account_id: @account.id, tag: @account.tag)

        # Wallet creation by Mangpay
        mangopay_wallet = MangoPay::Wallet.create(
          "Tag": @wallet.tag,
          "Owners": [Account.find(@wallet.account_id).mangopay_id],
          "Description": "ASANASANO Wallet",
          "Currency": "EUR"
        )

        # Recuperation of the Mangopay Id created for the wallet
        @wallet.mangopay_id = mangopay_wallet["Id"]
        @wallet.save
      rescue MangoPay::ResponseError => ex
        log_error = ex.message
      rescue => ex
        log_error = ex.message
      ensure
        MangopayLog.create(event: "wallet_creation",
                           mangopay_answer: mangopay_wallet,
                           user_id: @user.id.to_i,
                           error_logs: log_error)
      end

      redirect_to profile_path
    else
      render :new
    end
  end
  # rubocop:enable Metrics/AbcSize

  def edit
    authorize @account
  end

  def update
    authorize @account # Check authorization before update
    # Il faut récupérer l'ID du compte
    if @account.update(account_params)

      if @account.person_type == "NATURAL"
        mangopay_update_natural_user(@account.id)
      else
        mangopay_update_legal_user(@account.id)
      end
      redirect_to profile_path
    else
      render :edit
    end
  end

  # rubocop:disable Metrics/AbcSize
  def mangopay_create_natural_user(account_id)
    @account = Account.find(account_id)

    mangopay_user = MangoPay::NaturalUser.create(
      "Tag": @account.tag,
      "Email": @user.email,
      "FirstName": @account.first_name,
      "LastName": @account.last_name,
      # Pb de format quand champ vide car il me faut a minima un caractère
      "Address":
      { "AddressLine1": @account.address_line1,
        "AddressLine2": @account.address_line2,
        "City": @account.city,
        "Region": @account.region,
        "PostalCode": @account.postal_code,
        "Country": @account.country_of_residence },
      "Birthday": @account.birthday.to_time.to_i,
      "Nationality": @account.nationality,
      "CountryOfResidence": @account.country_of_residence
    )

    @account.mangopay_id = mangopay_user["Id"]
    @account.save
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "natural_account_creation",
                       mangopay_answer: mangopay_user,
                       user_id: @user.id.to_i,
                       error_logs: log_error)
  end

  def mangopay_create_legal_user(account_id)
    @account = Account.find(account_id)

    mangopay_user = MangoPay::LegalUser.create(
      "Tag": @account.tag,
      "Email": @user.email,
      "Name": @account.legal_name,
      "LegalPersonType": @account.legal_person_type,
      "LegalRepresentativeFirstName": @account.legal_representative_first_name,
      "LegalRepresentativeLastName": @account.legal_representative_last_name,
      "LegalRepresentativeBirthday": @account.legal_representative_birthday.to_time.to_i,
      "LegalRepresentativeNationality": @account.legal_representative_country_of_residence,
      "LegalRepresentativeCountryOfResidence":
        @account.legal_representative_country_of_residence
    )

    @account.mangopay_id = mangopay_user["Id"]
    @account.save
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "legal_account_creation",
                       mangopay_answer: mangopay_user,
                       user_id: @user.id.to_i,
                       error_logs: log_error)
  end

  def mangopay_update_natural_user(account_id)
    @account = Account.find(account_id)

    mangopay_natural_user_update = MangoPay::NaturalUser.update(
      @account.mangopay_id,
      Tag: @account.tag,
      Email: @user.email,
      FirstName: @account.first_name,
      LastName: @account.last_name,
      Birthday: @account.birthday.to_time.to_i,
      Nationality: @account.nationality,
      Address: { AddressLine1: @account.address_line1,
                 AddressLine2: @account.address_line2,
                 City: @account.city,
                 Region: @account.region,
                 PostalCode: @account.postal_code,
                 Country: @account.country_of_residence },
      CountryOfResidence: @account.country_of_residence
    )
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "natural_account_update",
                       mangopay_answer: mangopay_natural_user_update,
                       user_id: @user.id.to_i,
                       error_logs: log_error)
  end

  def mangopay_update_legal_user(account_id)
    @account = Account.find(account_id)

    mangopay_legal_user_update = MangoPay::LegalUser.update(
      @account.mangopay_id,
      Tag: @account.tag,
      Email: @user.email,
      Name: @account.legal_name,
      LegalPersonType: @account.legal_person_type,
      LegalRepresentativeFirstName: @account.legal_representative_first_name,
      LegalRepresentativeLastName: @account.legal_representative_last_name,
      LegalRepresentativeBirthday: @account.legal_representative_birthday.to_time.to_i,
      LegalRepresentativeNationality: @account.legal_representative_country_of_residence,
      LegalRepresentativeCountryOfResidence: @account.legal_representative_country_of_residence
    )
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "legal_account_update",
                       mangopay_answer: mangopay_legal_user_update,
                       user_id: @user.id.to_i,
                       error_logs: log_error)
  end
  # rubocop:enable Metrics/AbcSize

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def find_account
    @account = Account.find(@user.account.id)
  end

  def account_params
    params.require(:account).permit(:user_id, :first_name, :last_name,
                                    :person_type, :tag,
                                    :birthday, :address_line1, :address_line2,
                                    :city, :region, :postal_code,
                                    :country_of_residence,
                                    :nationality, :legal_person_type,
                                    :legal_name,
                                    :legal_representative_first_name,
                                    :legal_representative_last_name,
                                    :legal_representative_birthday,
                                    :headquarters_address,
                                    :legal_representative_country_of_residence,
                                    :legal_representative_nationality)
  end

  def set_log_error
    # rubocop:disable UselessAssignment
    log_error = nil
    # rubocop:enable UselessAssignment
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ClassLength
