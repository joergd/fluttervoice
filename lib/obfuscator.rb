require 'encryption_system'

module Obfuscator

  ENCRYPTION_PASS_PHRASE = "obfuser"

  def Obfuscator.encrypt(s)
    EncryptionSystem::TEA.encrypt(s, ENCRYPTION_PASS_PHRASE)
  end

  def Obfuscator.decrypt(s)
    EncryptionSystem::TEA.decrypt(s, ENCRYPTION_PASS_PHRASE)
  end

  def Obfuscator.hashem(s)
    h = {}
    a = s.split(',')
    a.map do |x|
      pair = x.split('=')
      h[pair[0].to_sym] = pair[1]
    end
    h
  end

end