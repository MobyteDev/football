class Post < ApplicationRecord

  mount_uploader :picurl, DishUploader

  mount_base64_uploader :picurl, DishUploader
end
