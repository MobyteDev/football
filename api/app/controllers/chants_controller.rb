class ChantsController < APIBaseController
  # before_action :load_superuser, except: :create
  # authorize_resource except: :create
  # before_action :auth_user, except: :create

  def index
    chants = Chant.all
    if chants.empty?
      render status: 204
    else
      render json: chants
    end
  end

  def show
    @chant = Chant.find(params[:id])
    if @chant.errors.blank?
      render json: @chant, status: :ok
    else
      render json: @chant.errors, status: :bad_request
    end
  end

  def update
    @chant.update(update_chant_params)
    if @chant.errors.blank?
      render status: :ok
    else
      render json: @chant.errors, status: :bad_request
    end
  end

  def create
    @chant = Superuser.create(create_chant_params)
    if @chant.errors.blank?
      render status: :ok
    else
      render json: @chant.errors, status: :bad_request
    end
  end

  def destroy
    @chant = Product.find(params[:id])
    if @chant.errors.blank?
      @chant.destroy
      render status: :ok
    else
      render json: @chant.errors, status: :bad_request
    end
  end

  protected

  def default_chant_fields
    %i[title content]
  end

  def update_chant_params
    params.required(:chant).permit(
      *default_chant_fields
    )
  end

  def create_chant_params
    params.required(:chant).permit(
      *default_chant_fields
    )
  end
end
