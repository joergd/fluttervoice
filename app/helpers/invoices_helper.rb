module InvoicesHelper
  def html_options_for_line_item_types(line_item_types)
    line_item_types.collect { |option| "<option value=\"#{option.id}\">#{option.name}</option>" }
  end
end
