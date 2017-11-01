class AddSocialLinksToCoaches < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :website, :string
    add_column :coaches, :facebook, :string
    add_column :coaches, :instagram, :string
    add_column :coaches, :youtube, :string
    add_column :coaches, :twitter, :string
    add_column :coaches, :linkedin, :string
    add_column :coaches, :pinterest, :string
  end
end
