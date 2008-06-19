class Invoice < Document
  def name
    use_tax? ? "Tax Invoice #{number}" : "Invoice #{number}"
  end
end
