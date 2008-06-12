module PaymentGateway
  
  def self.generate_transaction_ref(subdomain, plan_id)
    code = subdomain[0..2]
    code += Time.now.utc.strftime("%y%m%d%H%M%S")
    code += plan_id.to_s
    code += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[rand(25),1]
    code.upcase
  end
  
end
