class ProductsController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @products = Product.where(parent_id: 0)

    filter_products
    load_filter_options
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def filter_products
    if params[:sport_ids].present?
      @products = @products.joins(:sports).where(sports: { id: params[:sport_ids] })
    end

    if params[:material_ids].present?
      @products = @products.joins(:materials).where(materials: { id: params[:material_ids] })
    end

    if params[:min_price].present?
      @products = @products.where('price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @products = @products.where('price <= ?', params[:max_price])
    end
  end

  def load_filter_options
    @sports = available_sports
    @materials = available_materials
  end

  def available_sports
    base_query = Sport.joins(:products).where(products: { parent_id: 0 })

    # Filter by materials if selected
    if params[:material_ids].present?
      base_query = base_query.joins(products: :materials)
                             .where(materials: { id: params[:material_ids] })
    end

    # Filter by price range if set
    if params[:min_price].present?
      base_query = base_query.where('products.price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      base_query = base_query.where('products.price <= ?', params[:max_price])
    end

    base_query.distinct.order(:name)
  end

  def available_materials
    base_query = Material.joins(:products).where(products: { parent_id: 0 })

    # Filter by sports if selected
    if params[:sport_ids].present?
      base_query = base_query.joins(products: :sports)
                             .where(sports: { id: params[:sport_ids] })
    end

    # Filter by price range if set
    if params[:min_price].present?
      base_query = base_query.where('products.price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      base_query = base_query.where('products.price <= ?', params[:max_price])
    end

    base_query.distinct.order(:name)
  end
end
