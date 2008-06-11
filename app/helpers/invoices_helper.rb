module InvoicesHelper
  def html_options_for_invoice_line_types(invoice_line_types)
    invoice_line_types.collect { |option| "<option value=\"#{option.id}\">#{option.name}</option>" }
  end
end
