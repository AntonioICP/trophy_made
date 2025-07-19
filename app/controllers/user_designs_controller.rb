class UserDesignsController < ApplicationController
require 'base64'

def create
  image_data = params[:design][:image_data]
  image_data.gsub!(/^data:image\/png;base64,/, '')
  decoded_data = Base64.decode64(image_data)

  filename = "design_#{Time.now.to_i}.png"
  filepath = Rails.root.join('public', 'uploads', filename)

  File.open(filepath, 'wb') { |f| f.write(decoded_data) }

  # Save path or name in DB if needed
#   @design = Design.new(image_path: "/uploads/#{filename}")
#   if @design.save
#     render json: { status: 'success', url: @design.image_path }
#   else
#     render json: { status: 'error' }, status: :unprocessable_entity
#   end
# end

end
