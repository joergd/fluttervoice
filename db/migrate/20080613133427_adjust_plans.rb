class AdjustPlans < ActiveRecord::Migration
  def self.up
    free = Plan.find(Plan::FREE)
    free.invoices = 3
    free.users = 1
    free.clients = 3
    free.save
    
    lite = Plan.find(Plan::LITE)
    lite.invoices = 15
    lite.users = 2
    lite.clients = 10
    lite.cost_for_za = 55
    lite.display_cost_for_za = "R55"
    lite.display_currency_cost_for_za = "ZAR55"
    lite.cost_for_com = 55
    lite.display_cost_for_com = "R55"
    lite.display_currency_cost_for_com = "ZAR55"
    lite.cost_for_uk = 55
    lite.display_cost_for_uk = "R55"
    lite.display_currency_cost_for_uk = "ZAR55"
    lite.save
    
    hardcore = Plan.find(Plan::HARDCORE)
    hardcore.invoices = 60
    hardcore.users = 5
    hardcore.clients = 50
    hardcore.cost_for_za = 120
    hardcore.display_cost_for_za = "R120"
    hardcore.display_currency_cost_for_za = "ZAR120"
    hardcore.cost_for_com = 120
    hardcore.display_cost_for_com = "R120"
    hardcore.display_currency_cost_for_com = "ZAR120"
    hardcore.cost_for_uk = 120
    hardcore.display_cost_for_uk = "R120"
    hardcore.display_currency_cost_for_uk = "ZAR120"
    hardcore.save

    hardcore = Plan.find(Plan::ULTIMATE)
    hardcore.invoices = 200
    hardcore.users = 10
    hardcore.clients = 200
    hardcore.cost_for_za = 300
    hardcore.display_cost_for_za = "R300"
    hardcore.display_currency_cost_for_za = "ZAR300"
    hardcore.cost_for_com = 300
    hardcore.display_cost_for_com = "R300"
    hardcore.display_currency_cost_for_com = "ZAR300"
    hardcore.cost_for_uk = 300
    hardcore.display_cost_for_uk = "R300"
    hardcore.display_currency_cost_for_uk = "ZAR300"
    hardcore.save
    
  end

  def self.down
  end
end
