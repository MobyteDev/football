class RoomChannel < ApplicationCable::Channel
  MESSAGE_TYPES = [1, 2, 3].freeze

  def subscribed
    if current_user.superuser?
      current_user.update(room_id: chat_id) # При хаходе в чат записываем в бд текущий чат
      unread_messages = Message.where(chat_id: chat_id, sender_type: 'User', status: false).update_all(status: true) # Читаем сообщение Админом при входе в чат с юзером
    else
      current_user.update(online: true)
      ActionCable.server.broadcast room_id, message: 'Пользователь вошел в чат!', user_online: current_user.online, sender_type: 'System', type_message: 1
    end
    stream_from room_id
  end

  def unsubscribed
    if current_user.superuser?
      current_user.update(room_id: nil)
      read_messages = Message.where(chat_id: chat_id, sender_type: 'User', status: false).update_all(status: true) # Читаем сообщение Админом при выходе из чата с юзером
      Message.where(type_message: 4).destroy_all
    else
      current_user.update(online: false)
      ActionCable.server.broadcast room_id, message: 'Пользователь вышел из чата!', user_online: current_user.online, sender_type: 'System', type_message: 1
    end
  end

  def receive(data)
    type_message = data['type_message']
    picture = data['picture']
    content = data['message']
    price = data['price']
    d_price = data['d_price']
    return if type_message != 2 && content.blank?

    return unless MESSAGE_TYPES.include?(type_message)

    new_message = Message.new(content: content, sender: current_user, chat_id: chat_id, picture: picture, type_message: type_message)
    return unless new_message.save

    ActionCable.server.broadcast room_id, message: content, picture: new_message.picture, type_message: type_message, sender_type: new_message.sender_type, created_at: new_message.created_at
    if data['type_message'] == 3
      d_string = "Здравствуйте! Вам доставку или самовывоз?\n\nСтоимость с доставкой: #{price + d_price}р (#{price}р + #{d_price}р доставка).\n\nСтоимость без доставки: #{price}р"
      Message.create(content: d_string, sender_type: "Superuser", sender_id: 1, chat_id: chat_id, type_message: 1)
      Message.create(content: "💵💵ЗАКАЗ", sender: current_user, chat_id: chat_id, type_message: 4)
      sleep 1.5
      ActionCable.server.broadcast room_id, message: d_string, type_message: 1, sender_type: 'Superuser'
    end
    notify_service = PushNotificationService.new(new_message, current_user, chat_id)
    notify_service.fcm_push_notification
  end

  protected

  def room_id
    "room_channel_#{chat_id}"
  end

  def chat_id
    if current_user.superuser?
      params['chat_id']
    else
      current_user.chat.id
    end
  end
end
