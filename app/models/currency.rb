class Currency < ActiveRecord::Base
  set_primary_key "code"

#  def self.import
#    require 'rexml/document'
#    xml = REXML::Document.new(File.open("c:\\currencies.xml"))
#    xml.elements.each("//option") do |c|
#      curr = Currency.new
#      curr.abbreviation = c.attributes["value"]
#      curr.name = c.text
#      curr.save
#    end
#  end

end
