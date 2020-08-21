class Product < ApplicationRecord

  mount_uploader :picture, ProductUploader

  mount_base64_uploader :picture, ProductUploader
end
