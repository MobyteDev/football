class CommandChannel < ApplicationCable::Channel
  MESSAGE_TYPES = [1, 2].freeze

  def subscribed
    stream_from room_id
  end

  def unsubscribed
  
  end

  def receive(data)
    type_message = data['type_message']
    content = data['message']
    command = data['command']
    return if command.blank? && content.blank?

    ActionCable.server.broadcast room_id, message: content, command: command, sender_type: new_message.sender_type, created_at: Time.zone.now
  end

  protected

  def room_id
    "command_channel_#{chat_id}"
  end

  def chat_id
    1
  end
end
