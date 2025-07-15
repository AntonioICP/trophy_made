module ApplicationHelper
  def remove_filter_path(param_key, value = nil)
    new_params = params.to_unsafe_h.except(param_key.to_s)

    if value && params[param_key].is_a?(Array)
      remaining_values = Array(params[param_key]) - [value.to_s]
      new_params = new_params.merge(param_key.to_s => remaining_values) if remaining_values.any?
    end

    # Preserve open sections
    new_params['open_sections'] = params[:open_sections] if params[:open_sections].present?

    products_path(new_params)
  end
end
