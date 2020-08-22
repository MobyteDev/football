class CommandChannel < ApplicationCable::Channel
  REWARD_POINTS = 5.0.freeze

  def subscribed
    if !current_user.superuser?
      current_user.update(online: true)
      ActionCable.server.broadcast room_id, message: 'Пользователь вошел в флешмоб!', user_id: current_user.id, sender_type: 'System', count_online: User.where(online: true).count
    end
    stream_from room_id
    if current_user.superuser?
      ActionCable.server.broadcast room_id, message: "Здравствуйте, начинайте флешмоб, вас ждут #{User.where(online: true).count} болельщиков!", sender_type: 'System', count_online: User.where(online: true).count
    end
  end

  def unsubscribed
    if !current_user.superuser?
      current_user.update(online: false)
      ActionCable.server.broadcast room_id, message: 'Пользователь вышел из флешмоба!', user_id: current_user.id, sender_type: 'System', count_online: User.where(online: true).count
    end

  end

  def receive(data)
    check_in = data['check_in']
    if check_in == :ok
      current_user.add_rank(REWARD_POINTS)

  end

  protected

  def room_id
    "command_channel_#{chat_id}"
  end

  def chat_id
    1
  end
end
