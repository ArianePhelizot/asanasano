# frozen_string_literal: true
# == Schema Information
#
# Table name: coaches
#
#  id            :integer          not null, primary key
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  experience    :integer
#  languages     :text             default([]), is an Array
#  params_set_id :integer
#
# Indexes
#
#  index_coaches_on_params_set_id  (params_set_id)
#

class Coach < ApplicationRecord
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :groups
  has_one :user
  has_many :courses, dependent: :nullify
  has_attachment :photo
  belongs_to :params_set

  delegate :first_name, to: :user
  delegate :photo, to: :course, prefix: true

  validates :experience, numericality: { allow_nil: true }, inclusion: { in: 0...50 }
  validates :params_set_id, presence: true

  def name
    "#{user&.first_name} #{user&.last_name} "
  end
end
