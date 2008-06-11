class CreateSomeCurrencies < ActiveRecord::Migration
  def self.up
    c = Currency.new(:name => "South Africa Rand", :symbol => "R")
    c.id = "ZAR"
    c.save

    c = Currency.new(:name => "United States Dollar", :symbol => "$")
    c.id = "USD"
    c.save

    c = Currency.new(:name => "Great Britain Pound", :symbol => "£")
    c.id = "GBP"
    c.save
  end

  def self.down
    Currency.delete_all
  end
end
