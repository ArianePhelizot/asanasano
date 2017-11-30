# frozen_string_literal: true

# == Schema Information
#
# Table name: sports
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon       :string
#

class Sport < ApplicationRecord
  has_and_belongs_to_many :coaches
  has_many :courses, dependent: :nullify
  mount_uploader :icon, IconUploader

  validates :name, presence: true
  validates :icon, presence: true

  after_validation :report_validation_errors_to_rollbar
end
