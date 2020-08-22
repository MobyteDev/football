class GeneralChannel < ApplicationCable::Channel
  MESSAGE_TYPES = [1, 2].freeze

  def subscribed
    stream_from room_id
  end

  def unsubscribed
  
  end

  def receive(data)
    type_message = data['type_message']
    picture = data['picture']
    content = data['message']
    return if type_message != 2 && content.blank?

    return unless MESSAGE_TYPES.include?(type_message)

    new_message = Message.new(content: content, sender: current_user, chat_id: chat_id, picture: picture, type_message: type_message, sender_name: current_user.name)
    return unless new_message.save

    ActionCable.server.broadcast room_id, message: content, picture: new_message.picture, type_message: type_message, sender_type: new_message.sender_type, sender_id:new_message.sender_id, sender_name: current_user.name, created_at: new_message.created_at
    # notify_service = PushNotificationService.new(new_message, current_user, chat_id)
    # notify_service.fcm_push_notification
  end

  protected

  def room_id
    "general_channel_#{chat_id}"
  end

  def chat_id
    6
  end
end
