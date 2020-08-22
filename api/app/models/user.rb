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

  def add_rank(count)
    new_rank = self.rank + count
    self.update(rank: new_rank)
  end

  def as_json(_options = {})
    {
        id: self.id,
        name: self.name,
        phone_number: self.phone_number,
        created_at: self.created_at,
        updated_at: self.updated_at,
        online: self.online,
        surname: self.surname,
        birthday: self.birthday,
        gender: self.gender,
        email: self.email,
        caption: self.caption,
        rank: self.rank,
        basket: self.basket,
        avatar: self.avatar,
        place: self.get_place.as_json
      }
  end


  protected

  def get_place
    users = User.all.order(rank: :desc)
    users.to_a.each_index { |x| @place = x + 1 if users[x] == self}
    @place
  end

  def create_chat
    Chat.create(user_id: id)
  end
end
