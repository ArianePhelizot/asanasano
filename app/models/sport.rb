class Sport < ApplicationRecord
  has_attachments :photos
  has_many :coaches, through: :coaches_sports

  validates :name, presence: true
end
