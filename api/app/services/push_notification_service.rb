class PushNotificationService
  USER_TITLE = '📨 У вас новое сообщение от ресторана!'.freeze
  SUPERUSER_TITLE = '📨 У вас новое сообщение от'.freeze
  SUPERUSER_ORDER_TITLE = '📝 У вас заказ от'.freeze
  SUPERUSER_ID = 1

  attr_reader :response, :success_counter, :failure_counter
  attr_accessor :chat_id

  def initialize(message, user, chat_id)
    @message = message
    @user = user
    @response = nil
    @success_counter = 0
    @failure_counter = 0
    @chat_id = chat_id
    @chat = Chat.find(chat_id)
    @superuser = nil
  end

  def fcm_push_notification(priority = 'high')
    fcm_client = FCM.new(Rails.application.secrets.api_fcm_token) # set your FCM_SERVER_KEY

    options = {
      priority: priority,
      collapseKey: chat_id.to_s,
      data: { message: @message.content,
              chat_id: @chat_id,
              phone_number: @chat.user.name },
      notification: {
        body: body.truncate(265),
        android_channel_id: '1',
        title: title,
        sound: 'default',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    }
    return unless need_notify?

    @response = fcm_client.send(push_token, options)
  end

  private

  def push_token
    if @user.superuser?
      @chat.user.push_token
    else
      superuser.push_token
    end
  end

  def need_notify?
    if @user.superuser?
      user_need_notify?
    else
      superuser_need_notify?
    end
  end

  def superuser_need_notify?
    superuser.room_id != @chat_id
  end

  def user_need_notify?
    !@chat.user.online?
  end

  def body
    case @message.type_message
    when 1
      @message.content
    when 2
      'Фотография'
    when 3
      @message.content.to_s if @user.is_a?(User)
    end
  end
  
  def image
    if !@user.superuser?
      'https://mobyte.dev/server/buyer.png'
    else
      'https://mobyte.dev/server/customer-support.png'
    end
  end

  def title
    if @user.superuser?
      SUPERUSER_TITLE + ' ' + @chat.user.name
    elsif !@user.superuser? && @message.type_message == 3
      SUPERUSER_ORDER_TITLE + ' ' + @chat.user.phone_number
    else
      SUPERUSER_TITLE + ' ' + @chat.user.name
    end
  end

  def superuser
    @superuser ||= Superuser.find(SUPERUSER_ID)
  end
end
