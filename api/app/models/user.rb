class User < ApplicationRecord
  extend Enumerize

  after_create :create_chat

  validates :phone_number, presence: true, uniqueness: { case_sensitive: true }

  has_secure_password validations: false
  has_one :chat, dependent: :destroy

  enumerize :role, in: %i[user], default: :user, predicates: true, scope: :shallow

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

  def banned?
    banned
  end

  def generate_password(phone_number)
    new_password = '0000' # TODO: Пока что поумолчанию пароль 0000, потом рандом
    # p new_password = rand(0000..9999).to_s.rjust(4, '0')
    self.password = new_password
    save
    call_service = CallPasswordService.new(phone_number, new_password)
    response = call_service.send_request_call_password
    return response = JSON.parse(response.body)
    # fcm_client = FCM.new(Rails.application.secrets.api_fcm_token) # set your FCM_SERVER_KEY
    # options = { priority: 'high',
    #             notification: { body: "Ваш pin для входа: #{new_password}",
    #                             title: 'Авторизация',
    #                             sound: 'default',
    #                             tag: 'pin',
    #                             click_action: 'FLUTTER_NOTIFICATION_CLICK',
    #                             color: '#ff0000' } }
    # response = fcm_client.send(push_t, options) # TODO: Пока что приходит push вместо SMS
    #  response = JSON.parse(response[:body]).deep_transform_keys(&:to_sym)
  end

  protected

  def create_chat
    Chat.create(user_id: id)
  end
end
