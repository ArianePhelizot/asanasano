class Sport < ApplicationRecord
  has_attachement :photo
  has_attachement :icon
  has_many :coaches, through: :coaches_sports

  validates :name, :photo, :icon, presence: true

end
