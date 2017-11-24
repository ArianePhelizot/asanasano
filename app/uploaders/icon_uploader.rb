# encoding: utf-8

class IconUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
