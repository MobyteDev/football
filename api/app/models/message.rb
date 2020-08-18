class Message < ApplicationRecord
  after_create :update_time_chat

  mount_uploader :picture, MessageImageUploader
  mount_base64_uploader :picture, MessageImageUploader

  belongs_to :sender, polymorphic: true
  belongs_to :chat

  protected

  def update_time_chat
    chat.update(updated_at: Time.now)
  end
end
