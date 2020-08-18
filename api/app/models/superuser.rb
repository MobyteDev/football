class Superuser < ApplicationRecord
  extend Enumerize

  validates :login, presence: true, uniqueness: { case_sensitive: true }
  has_secure_password

  enumerize :role, in: %i[admin], default: :admin, predicates: true, scope: :shallow

  def to_token_payload
    {
      sub: id,
      class: self.class.to_s
    }
  end

  def self.from_token_request(request)
    login = request.params&.[]('auth')&.[]('login')
    find_by login: login
  end

  def self.from_token_payload(payload)
    find(payload['sub']) if payload['sub'] && payload['class'] && payload['class'] == to_s
  end

  def superuser?
    true
  end
end
