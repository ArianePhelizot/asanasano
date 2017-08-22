# rubocop:disable Metrics/ClassLength
class AccountsController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  before_action :set_user
  before_action :find_account, only: [:edit, :update]

  def new
    @account = Account.new(user_id: @user.id)
    authorize @account
  end

  def create
    @account = Account.new(account_params)
    authorize @account

    if @account.save
      if @account.person_type == "NATURAL"
        mangopay_create_natural_user(@account.id)
      else
        mangopay_create_legal_user(@account.id)
      end

      redirect_to profile_path
    else
      render :new
    end
  end

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
  rescue MangoPay::ResponseError => ex # rubocop:disable UselessAssignment
    raise
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
  rescue MangoPay::ResponseError => ex # rubocop:disable UselessAssignment
    raise
  end

  def mangopay_update_natural_user(account_id)
    @account = Account.find(account_id)

    MangoPay::NaturalUser.update(
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
  rescue MangoPay::ResponseError => ex # rubocop:disable UselessAssignment
    raise
  end

  def mangopay_update_legal_user(account_id)
    @account = Account.find(account_id)

    MangoPay::LegalUser.update(
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
  rescue MangoPay::ResponseError => ex # rubocop:disable UselessAssignment
    raise
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
    params.require(:account).permit(:user_id, :first_name, :last_name, :person_type, :tag,
                                    :birthday, :address_line1, :address_line2,
                                    :city, :region, :postal_code, :country_of_residence,
                                    :nationality, :legal_person_type, :legal_name,
                                    :legal_representative_first_name,
                                    :legal_representative_last_name,
                                    :legal_representative_birthday,
                                    :headquarters_address,
                                    :legal_representative_country_of_residence,
                                    :legal_representative_nationality)
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ClassLength
