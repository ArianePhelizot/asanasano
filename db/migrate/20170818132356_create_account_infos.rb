class CreateAccountInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :account_infos do |t|
    t.references :user, foreign_key: true, index: true
    t.string :person_type
    t.string :tag
    # For natural users
    t.string :first_name
    t.string :last_name
    t.timestamp :birthday
    t.string :address
    t.string :country_of_residence
    t.string :nationality
    # For legal users
    t.string :legal_person_type
    t.string :legal_name
    t.string :legal_representative_first_name
    t.string :legal_representative_last_name
    t.timestamp :legal_representative_birthday
    t.string  :headquarters_address
    t.string :legal_representative_country_of_residence
    t.string :legal_representative_nationality

    t.timestamps
    end
  end
end
