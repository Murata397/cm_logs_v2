# 画像の添付ファイルに「種類」と「大きさ」のチェックをつける
#   使い方：validates_image :profile_image
module ImageValidatable
  extend ActiveSupport::Concern

  IMAGE_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  MAX_IMAGE_SIZE = 5.megabytes

  class_methods do
    def validates_image(name)
      validate do
        file = public_send(name)
        next unless file.attached?

        unless file.content_type.in?(IMAGE_TYPES)
          errors.add(name, "は画像ファイル（JPEG・PNG・WebP・GIF）を選んでください")
        end
        if file.byte_size > MAX_IMAGE_SIZE
          errors.add(name, "は5MB以下にしてください")
        end
      end
    end
  end
end
