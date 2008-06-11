class Address
  attr_reader :address1, :address2, :city, :state, :postalcode, :country

  def initialize(address1, address2, city, state, postalcode, country)
    @address1 = address1
    @address2 = address2
    @city = city
    @state = state
    @postalcode = postalcode
    @country = country
  end

  def lines
    [ @address1.blank? ? nil : @address1,
      @address2.blank? ? nil : @address2,
      @city.blank? ? nil : @city,
      @state.blank? ? nil : @state,
      @postalcode.blank? ? nil : @postalcode,
      @country.blank? ? nil : @country ].compact
  end
  
  def vcard_lines
    [ @address1.blank? ? nil : "<span class='street-address'>#{CGI::escapeHTML(@address1)}</span>",
      @address2.blank? ? nil : "<span class='extended-address'>#{CGI::escapeHTML(@address2)}</span>",
      @city.blank? ? nil : "<span class='locality'>#{CGI::escapeHTML(@city)}</span>",
      @state.blank? ? nil : "<span class='region'>#{CGI::escapeHTML(@state)}</span>",
      @postalcode.blank? ? nil : "<span class='postal-code'>#{CGI::escapeHTML(@postalcode)}</span>",
      @country.blank? ? nil : "<span class='country-name'>#{CGI::escapeHTML(@country)}</span>" ].compact
  end
  
  def blank?
    lines.size == 0
  end
  
end
