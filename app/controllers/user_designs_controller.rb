class UserDesignsController < ApplicationController
require 'base64'

  def create
    image_data = params[:user_design][:image_data]

    # Remove data URL prefix
    image_data.gsub!(/^data:image\/png;base64,/, '')
    decoded_data = Base64.decode64(image_data)

    # Create a temporary file
    temp_file = Tempfile.new(['design', '.png'])
    temp_file.binmode
    temp_file.write(decoded_data)
    temp_file.rewind

    # Create user design record and attach to Cloudinary
    user_design = UserDesign.new(
      product_id: params[:user_design][:product_id],
      user_id: current_user&.id, # if you have authentication
      finished: false
    )

    # Attach to Active Storage (which uploads to Cloudinary)
    user_design.design_image.attach(
      io: temp_file,
      filename: "design_#{Time.now.to_i}.png",
      content_type: 'image/png'
    )

    if user_design.save
      render json: {
        success: true,
        cloudinary_url: user_design.design_image.attached? ? url_for(user_design.design_image) : nil
      }
    else
      render json: { success: false, errors: user_design.errors }
    end

    temp_file.close
    temp_file.unlink
  end
end
