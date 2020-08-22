class CategoriesController < APIBaseController
  authorize_resource except: %i[index show]

  def index
    categoryes = Category.all.order(:id)
    if categoryes.blank?
      render status: :no_content
    else
      render json: categoryes, status: :ok
    end
  end

  def show
    category = Category.find(params[:id])
    if category.errors.blank?
      render json: category, status: :ok
    else
      render json: category.errors, status: :bad_request
    end
  end

  def update
    category = Category.update(update_category_params)
    if category.errors.blank?
      render status: :ok
    else
      render json: category.errors, status: :bad_request
    end
  end

  def create
    category = Category.create(create_category_params)
    if category.errors.blank?
      render status: :ok
    else
      render json: category.errors, status: :bad_request
    end
  end

  def destroy
    category = Category.find(params[:id])
    if category.errors.blank?
      category.delete
      render status: :ok
    else
      render json: category.errors, status: :bad_request
    end
  end

  protected

  def default_category_fields
    %i[name icon_index]
  end

  def update_category_params
    params.required(:category).permit(
      *default_category_fields
    )
  end

  def create_category_params
    params.required(:category).permit(
      *default_category_fields
    )
  end
end
