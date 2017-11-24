# encoding: utf-8

class InsuranceUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
