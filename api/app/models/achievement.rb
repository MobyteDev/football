class Achievement < ApplicationRecord
  

  mount_uploader :picture, AchievementUploader

  mount_base64_uploader :picture, AchievementUploader
end
