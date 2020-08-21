class ProductsController< APIBaseController
  authorize_resource except: %i[index show]

  before_action :auth_user, except: %i[index show]

  def index
    products = Product.all
    if products.empty?
      render status: 204
    else
      render json: products
    end
  end

  def show
    @product = Product.find(params[:id])
    if @product.errors.blank?
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :bad_request
    end
  end

  def update
    @product = Product.find(params[:id])
    if params[:file_name].present?
      @product.remove_picture!
      @product.save
      @redis.set('file_name', params[:file_name])
    else
      @redis.set('file_name', "picture")
    end
    @product.update(update_product_params)
    if @product.errors.blank?
      render status: :ok
    else
      render json: @product.errors, status: :bad_request
    end
  end

  def create
    @product = Product.create(create_product_params)
    if @product.errors.blank?
      render status: :ok
    else
      render json: @product.errors, status: :bad_request
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.errors.blank?
      @product.delete
      @product.remove_picurl!
      @product.save
      render status: :ok
    else
      render json: @product.errors, status: :bad_request
    end
  end

  protected

  def default_producth_fields
    %i[caption1 title picture content]
  end

  def update_product_params
    params.required(:product).permit(
      *default_product_fields
    )
  end

  def create_product_params
    params.required(:product).permit(
      *default_product_fields
    )
  end
end
