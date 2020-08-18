class UsersController < APIBaseController
  before_action :load_user, except: %i[create location_shop]
  authorize_resource except: %i[create location_shop]
  before_action :auth_user, except: %i[create location_shop]

  def show
    render json: @user.to_json(except: %i[password_digest push_token])
  end

  def update
    @user.update(update_user_params)
    if @user.errors.blank?
      render status: :ok
    else
      render json: @user.errors, status: :bad_request
    end
  end

  def create
    @phone_number = create_user_params['phone_number']
    if User.where(phone_number: @phone_number).present?
      @user = User.find_by(phone_number: @phone_number)
      p response = @user.generate_password(@phone_number)
      render json: response, status: :ok
    else
      @user = User.create(create_user_params)
      p response =  @user.generate_password(@phone_number)
      render json: response, status: :ok
    end
  end

  protected

  def load_user
    @user = current_user
  end

  def default_user_fields
    %i[name push_token basket]
  end

  def update_user_params
    params.required(:user).permit(
      *default_user_fields
    )
  end

  def create_user_params
    params.required(:user).permit(
      *default_user_fields, :phone_number
    )
  end
end
