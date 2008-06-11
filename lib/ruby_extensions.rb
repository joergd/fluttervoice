require 'obfuscator'

class String
  def obfuscate
    Obfuscator::encrypt(self)
  end
end


# Won't need this with a newer Rails version!!
class Time   
  %w(to_date to_datetime).each do |method|   
    public method if private_instance_methods.include?(method)   
  end   
end
