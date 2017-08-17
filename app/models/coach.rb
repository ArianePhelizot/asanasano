# frozen_string_literal: true

# == Schema Information
#
# Table name: coaches
#
#  id          :integer          not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  experience  :integer
#  languages   :text             default([]), is an Array
#

class Coach < ApplicationRecord
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :groups
  has_one :user
  has_many :courses, dependent: :nullify
  has_attachment :photo

  delegate :first_name, to: :user
  delegate :photo, to: :course, prefix: true

  validates :experience, numericality: { allow_nil: true }, inclusion: { in: 0...50 }

  def name
    "#{user&.first_name} #{user&.last_name} "
  end
end
