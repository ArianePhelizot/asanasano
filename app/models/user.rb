# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  coach_id               :integer
#  phone_number           :string
#  provider               :string
#  uid                    :string
#  facebook_picture_url   :string
#  token                  :string
#  token_expiry           :datetime
#  admin                  :boolean          default(FALSE), not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  photo                  :string
#  user_terms_acceptance  :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_coach_id              (coach_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_and_belongs_to_many :groups
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :nullify
  belongs_to :coach, optional: true
  has_and_belongs_to_many :slots
  has_one :account, dependent: :nullify
  has_many :orders, dependent: :nullify
  has_many :mangopay_logs, dependent: :nullify

  mount_uploader :photo, PhotoUploader

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :invitable, :omniauthable, omniauth_providers: [:facebook]

  validates :user_terms_acceptance, acceptance: true
  # validates_acceptance_of :user_terms_acceptance, allow_nil: false,
  #                                           message: :terms_not_accepted, on: [:create, :update]

  after_create :send_welcome_email

  def coach?
    coach_id.present?
  end

  def group_list
    group_list = groups
    if coach?
      coach = Coach.find(coach_id)
      coach.courses.each do |course|
        group_list << course.group
      end
    end
    group_list.uniq
  end

  def next_slots
    active_slots = slots.select { |slot| slot.status == "created" || slot.status == "confirmed" }
    sorted_slots = active_slots.sort_by(&:start_at)
    sorted_slots.select { |slot| slot.start_at >= Time.now }
  end

  def available_courses
    user_courses = []
    groups.each do |group|
      user_courses << group.courses
    end
    user_courses.flatten
  end

  def next_available_slots
    next_available_slots = []
    available_courses.each do |course|
      next_available_slots << course.next_slots
    end
    next_available_slots.flatten.sort_by(&:start_at)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def self.find_for_facebook_oauth(auth)
    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params[:user_terms_acceptance] = "1"
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      user.save
    end

    user
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def mail_root
    match_data = email.match(/(..*)*@/)
    match_data[1]
  end

  def dashboard_coach_next_slots
    # Je prends un user-coach
    # Je regarde tous ces cours
    dashboard_coach_next_slots = []
    coach = Coach.find(coach_id)
    coach.courses.each do |course|
      dashboard_coach_next_slots << course.next_slots
    end
    dashboard_coach_next_slots.flatten.sort_by(&:start_at)
  end

  def user_profile_complete?
    first_name && last_name && phone_number && photo
  end

  def send_welcome_pro_email
    UserMailer.welcome_pro(self).deliver_now
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now unless invitation_token?
  end
end
