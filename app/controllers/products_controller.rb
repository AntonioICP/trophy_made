class ProductsController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @products = Product.where(parent_id: 0)
  end

  def show
    @product = Product.find(params[:id])
  end
end
