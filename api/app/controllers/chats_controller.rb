class ChatsController < APIBaseController
  authorize_resource
  before_action :auth_user

  def index
    if current_superuser.present?
      chats = Chat.all.order(updated_at: :desc).page(params[:page])
      if chats.empty?
        render status: :no_content
      else
        render json: chats
      end
    else
      render json: { "admin": 'no unauthorized' }, status: 401
    end
  end

  def show
    if current_superuser.present?
      messages = Message.where(chat_id: params[:id])
      if messages.empty?
        render status: :no_content
      else
        render json: messages, status: :ok
      end
    else
      render json: { "admin": 'no unauthorized' }, status: 401
    end
  end

  def update; end

  def destroy
    message = Message.find(params[:id])
    if message.errors.blank?
      message.delete
      message.remove_picture!
      message.save
      render status: :ok
    else
      render json: @message.errors, status: :bad_request
    end
  end
end
