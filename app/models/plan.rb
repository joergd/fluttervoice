class Plan < ActiveRecord::Base
  has_many  :accounts
  
  FREE, LITE, HARDCORE, ULTIMATE = 1, 2, 3, 4
  
  def free?
    id == FREE
  end
  
  def paid?
    id != FREE
  end
  
  # site = com/uk/za
  # displays the field from the db. Probably something like 400
  def cost(site)
    self.send("cost_for_#{site}")
  end

  # site = com/uk/za
  # displays the field from the db. Probably something like R400
  def display_cost(site)
    self.send("display_cost_for_#{site}")
  end
  
  # site = com/uk/za
  # displays the field from the db + /month. Probably something like R400/month
  def display_montly_cost(site)
    s = self.send("display_cost_for_#{site}")
    s += "/month" if id > FREE
    s
  end

  # site = com/uk/za
  # displays the field from the db. Probably something like ZAR400
  # Velocity Pay needs the amounts displayed like this.
  def display_currency_cost(site)
    self.send("display_currency_cost_for_#{site}")
  end

  def summary(site)
    s = free? ? "This plan is free for as long as you like. " : "The #{name} plan cost #{display_montly_cost(site)}. "  
    s += "You will be able to send #{invoices} invoices/month, and the number of clients you can set are #{clients == 0 ? 'unlimited' : clients}. "
    s += "The free account will include a small Fluttervoice link at the bottom of all emails." if free?
    s
  end
end
