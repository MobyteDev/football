class UsersController < APIBaseController
  before_action :load_user, except: %i[create get_rating]
  authorize_resource except: %i[create get_rating]
  before_action :auth_user, except: %i[create get_rating]

  def show
    render json: @user
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
      @user = User.create(create_user_params)
      if @user.errors.blank?
        render status: :ok
      else
        render json: @user.errors, status: :bad_request
    end
  end

  def update_basket
    @user.update(basket: params[:basket])
    if @user.errors.blank?
      render status: :ok
    else
      render json: @user.errors, status: :bad_request
    end
  end

  def add_achievement
    @user.update(achievement: params[:achievement])
    if @user.errors.blank?
      render status: :ok
    else
      render json: @user.errors, status: :bad_request
    end
  end

  def get_rating
    users = User.where.not(id: 5).order(rank: :desc).page(params[:page])
    if users.empty?
      render status: :no_content
    else
      render json: users.to_json(except: %i[id name surname rank avatar])
    end
  end


  protected


  def load_user
    @user = current_user
  end

  def default_user_fields
    %i[name surname birthday email caption gender push_token avatar]
  end

  def update_user_params
    params.required(:user).permit(
      *default_user_fields, :password
    )
  end

  def create_user_params
    params.required(:user).permit(
      *default_user_fields, :phone_number, :password
    )
  end
end
