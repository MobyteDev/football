class Product < ApplicationRecord

  belongs_to :category

  mount_uploader :picture, ProductUploader

  mount_base64_uploader :picture, ProductUploader
end
