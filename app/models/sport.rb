class Sport < ApplicationRecord
  has_attachment :photo
  has_attachment :icon
  has_many :coaches, through: :coaches_sports

  validates :name, :photo, :icon, presence: true

end
