# https://www.murdo.ch/blog/build-a-contact-form-with-ruby-on-rails-part-1
class ContactMessage
  include ActiveModel::Model
  attr_accessor :name, :email, :phone_number, :company, :body
  validates :name, :email, :body, presence: true
end
