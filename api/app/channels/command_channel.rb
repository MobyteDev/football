class CommandChannel < ApplicationCable::Channel
  MESSAGE_TYPES = [1, 2].freeze

  def subscribed
    if !current_user.superuser?
      current_user.update(online: true)
      ActionCable.server.broadcast room_id, message: 'Пользователь вошел в флешмоб!', user_id: current_user.id, sender_type: 'System', count_online: User.where(online: true).count
    end
    stream_from room_id
  end

  def unsubscribed
    if !current_user.superuser?
      current_user.update(online: false)
      ActionCable.server.broadcast room_id, message: 'Пользователь вошел из флешмоба!', user_id: current_user.id, sender_type: 'System', count_online: User.where(online: true).count
    end

  end

  def receive(data)
    type_message = data['type_message']
    content = data['message']
    command = data['command']
    return if command.blank? && content.blank?

    ActionCable.server.broadcast room_id, message: content, command: command, sender_type: "Superuser", time: Time.zone.now, count_online: User.where(online: true).count
  end

  protected

  def room_id
    "command_channel_#{chat_id}"
  end

  def chat_id
    1
  end
end
