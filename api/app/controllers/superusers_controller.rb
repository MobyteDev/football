class SuperusersController < APIBaseController
  before_action :load_superuser, except: :create
  authorize_resource except: :create
  before_action :auth_user, except: :create

  def show
    render json: @superuser.to_json(except: [:password_digest])
  end

  def update
    @superuser.update(update_superuser_params)
    if @superuser.errors.blank?
      render status: :ok
    else
      render json: @superuser.errors, status: :bad_request
    end
  end

  def create
    @superuser = Superuser.create(create_superuser_params)
    if @superuser.errors.blank?
      render status: :ok
    else
      render json: @superuser.errors, status: :bad_request
    end
  end

  def destroy
    @superuser.delete
  end

  def online_users
    online_users = User.all.where(online: true)
    if online_users.empty?
      render status: :no_content
    else
      render json: online_users, except: %i[password_digest created_at], status: :ok
    end
  end

  def show_user
    user = User.find(params[:id])
    if user.errors.blank?
      render json: user, except: [:password_digest], status: :ok
    else
      render status: :bad_request
    end
  end

  protected

  def load_superuser
    @superuser = current_superuser
  end

  def default_superuser_fields
    %i[btn1 btn2 btn3 push_token login]
  end

  def update_superuser_params
    params.required(:superuser).permit(
      *default_superuser_fields
    )
  end

  def create_superuser_params
    params.required(:superuser).permit(
      *default_superuser_fields, :password
    )
  end
end
