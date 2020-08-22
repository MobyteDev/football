class User < ApplicationRecord
  extend Enumerize

  after_create :create_chat

  validates :phone_number, presence: true, uniqueness: { case_sensitive: true }

  has_secure_password validations: false
  has_one :chat, dependent: :destroy

  enumerize :role, in: %i[user], default: :user, predicates: true, scope: :shallow

  mount_uploader :avatar, UserUploader

  mount_base64_uploader :avatar, UserUploader

  def to_token_payload
    {
      sub: id,
      class: self.class.to_s
    }
  end

  def self.from_token_request(request)
    phone_number = request.params&.[]('auth')&.[]('phone_number')
    find_by phone_number: phone_number
  end

  def self.from_token_payload(payload)
    find(payload['sub']) if payload['sub'] && payload['class'] && payload['class'] == to_s
  end

  def superuser?
    false
  end


  protected

  def create_chat
    Chat.create(user_id: id)
  end
end
