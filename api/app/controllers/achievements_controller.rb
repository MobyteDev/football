class AchievementsController < APIBaseController
  authorize_resource except: %i[index show]

  before_action :auth_user, except: %i[index show]

  def index
    achievements = Achievement.all
    if achievements.empty?
      render status: 204
    else
      render json: achievements
    end
  end

  def show
    @achievement = Achievement.find(params[:id])
    if @achievement.errors.blank?
      render json: @achievement, status: :ok
    else
      render json: @achievement.errors, status: :bad_request
    end
  end

  def update
    @achievement = Achievement.find(params[:id])
    if params[:file_name].present?
      @achievement.remove_picture!
      @achievement.save
      @redis.set('file_name', params[:file_name])
    else
      @redis.set('file_name', "picture")
    end
    @achievement.update(update_product_params)
    if @achievement.errors.blank?
      render status: :ok
    else
      render json: @achievement.errors, status: :bad_request
    end
  end

  def create
    @achievement = Achievement.create(create_achievement_params)
    if @achievement.errors.blank?
      render status: :ok
    else
      render json: @achievement.errors, status: :bad_request
    end
  end

  def destroy
    @achievement = Achievement.find(params[:id])
    if @achievement.errors.blank?
      @achievement.delete
      @achievement.remove_picture!
      @achievement.save
      render status: :ok
    else
      render json: @achievement.errors, status: :bad_request
    end
  end

  protected

  def default_achievement_fields
    %i[caption name reward picture]
  end

  def update_achievement_params
    params.required(:achievement).permit(
      *default_achievement_fields
    )
  end

  def create_achievement_params
    params.required(:achievement).permit(
      *default_achievement_fields
    )
  end
end
