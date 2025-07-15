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
end
