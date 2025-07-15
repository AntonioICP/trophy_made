class ProductsController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @products = Product.where(parent_id: 0)

    filter_products
    sort_products
    load_filter_options
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def filter_products
    # Category filtering from home page
    if params[:category_type] == "sports"
      @products = @products.joins(:sports).distinct
    elsif params[:category_type] == "corporate"
      @products = @products.joins(:corporate_categories).distinct
    end

    # Product style filtering (for Medals, Cups, Plaques)
    if params[:product_style].present?
      @products = @products.joins(:product_styles).where(product_styles: { name: params[:product_style] })
    end

    # Existing filters
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

  def sort_products
    case params[:sort]
    when 'price_asc'
      @products = @products.order(price: :asc)
    when 'price_desc'
      @products = @products.order(price: :desc)
    when 'name_asc'
      @products = @products.order(name: :asc)
    when 'name_desc'
      @products = @products.order(name: :desc)
    else
      @products = @products.order(created_at: :desc) # Default sorting
    end
  end

  def load_filter_options
    @sports = available_sports
    @materials = available_materials
    @product_styles = available_product_styles
    @corporate_categories = available_corporate_categories
  end

  def available_sports
    base_query = Sport.joins(:products).where(products: { parent_id: 0 })

    # Filter by category type
    if params[:category_type] == "corporate"
      base_query = base_query.joins(products: :corporate_categories)
    end

    # Filter by product style
    if params[:product_style].present?
      base_query = base_query.joins(products: :product_styles)
                             .where(product_styles: { name: params[:product_style] })
    end

    # Filter by materials if selected
    if params[:material_ids].present?
      base_query = base_query.joins(products: :materials)
                             .where(materials: { id: params[:material_ids] })
    end

    # Filter by price range
    apply_price_filter_to_query(base_query).distinct.order(:name)
  end

  def available_materials
    base_query = Material.joins(:products).where(products: { parent_id: 0 })

    # Filter by category type
    if params[:category_type] == "sports"
      base_query = base_query.joins(products: :sports)
    elsif params[:category_type] == "corporate"
      base_query = base_query.joins(products: :corporate_categories)
    end

    # Filter by product style
    if params[:product_style].present?
      base_query = base_query.joins(products: :product_styles)
                             .where(product_styles: { name: params[:product_style] })
    end

    # Filter by sports if selected
    if params[:sport_ids].present?
      base_query = base_query.joins(products: :sports)
                             .where(sports: { id: params[:sport_ids] })
    end

    # Filter by price range
    apply_price_filter_to_query(base_query).distinct.order(:name)
  end

  def available_product_styles
    base_query = ProductStyle.joins(:products).where(products: { parent_id: 0 })

    # Filter by category type
    if params[:category_type] == "sports"
      base_query = base_query.joins(products: :sports)
    elsif params[:category_type] == "corporate"
      base_query = base_query.joins(products: :corporate_categories)
    end

    # Apply existing filters
    if params[:sport_ids].present?
      base_query = base_query.joins(products: :sports)
                             .where(sports: { id: params[:sport_ids] })
    end

    if params[:material_ids].present?
      base_query = base_query.joins(products: :materials)
                             .where(materials: { id: params[:material_ids] })
    end

    apply_price_filter_to_query(base_query).distinct.order(:name)
  end

  def available_corporate_categories
    base_query = CorporateCategory.joins(:products).where(products: { parent_id: 0 })

    # Only show if we're filtering by corporate
    return CorporateCategory.none unless params[:category_type] == "corporate"

    # Apply existing filters
    if params[:sport_ids].present?
      base_query = base_query.joins(products: :sports)
                             .where(sports: { id: params[:sport_ids] })
    end

    if params[:material_ids].present?
      base_query = base_query.joins(products: :materials)
                             .where(materials: { id: params[:material_ids] })
    end

    apply_price_filter_to_query(base_query).distinct.order(:name)
  end

  def apply_price_filter_to_query(query)
    query = query.where('products.price >= ?', params[:min_price]) if params[:min_price].present?
    query = query.where('products.price <= ?', params[:max_price]) if params[:max_price].present?
    query
  end
end
