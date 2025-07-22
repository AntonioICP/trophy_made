module ApplicationHelper
  def remove_filter_path(param_key, value = nil)
    new_params = params.to_unsafe_h.except(param_key.to_s)

    if value && params[param_key].is_a?(Array)
      remaining_values = Array(params[param_key]) - [value.to_s]
      new_params = new_params.merge(param_key.to_s => remaining_values) if remaining_values.any?
    end

    # Preserve open sections
    new_params['open_sections'] = params[:open_sections] if params[:open_sections].present?
    new_params['sort'] = params[:sort] if params[:sort].present?

    products_path(new_params)
  end

  def sport_path_by_name(sport_name)
    sport = Sport.find_by(name: sport_name)
    if sport
      products_path(category_type: "sports", sport_ids: [sport.id])
    else
      products_path(category_type: "sports")
    end
  end

  def award_path_by_name(award_name)
    award = CorporateCategory.find_by(name: award_name)
    if award
      products_path(category_type: "corporate", corporate_category_ids: [award.id])
    else
      products_path(category_type: "corporate")
    end
  end

  def medal_sport_path_by_name(sport_name)
    sport = Sport.find_by(name: sport_name)
    if sport
      products_path(product_style: "Medals", sport_ids: [sport.id])
    else
      products_path(product_style: "Medals")
    end
  end

  def cup_quality_path_by_name(quality_name)
    quality = Quality.find_by(name: quality_name)
    if quality
      products_path(product_style: @cup_names, quality_ids: [quality.id])
    else
      products_path(product_style: @cup_names)
    end
  end

  def plaque_quality_path_by_name(category_name)
    category = CorporateCategory.find_by(name: category_name)
    if category
      products_path(product_style: "Plaques", corporate_category_ids: [category.id])
    else
      products_path(product_style: "Plaques")
    end
  end

  def order_status_color(status)
    case status.to_s.downcase
    when 'pending'
      'warning'
    when 'processing'
      'info'
    when 'shipped'
      'primary'
    when 'delivered'
      'success'
    when 'cancelled'
      'danger'
    else
      'secondary'
    end
  end

  def status_icon(status)
    case status&.downcase
    when 'completed'
      'check-circle'
    when 'processing'
      'cog'
    when 'shipped'
      'truck'
    when 'cancelled'
      'times-circle'
    else
      'clock'
    end
  end
end
