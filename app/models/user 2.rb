require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern.
class User < Person
  belongs_to   :account,
              :class_name => "Account",
              :foreign_key => "primary_person_id"

  validates_uniqueness_of     :email, :scope => "account_id"

  validates_presence_of       :password, :if => :password_validations?
  validates_confirmation_of   :password, :if => :password_validations?
  validates_length_of         :password, :within => 5..40, :if => :password_validations?

  def initialize(attributes = nil)
    super
    @new_password = false
  end

  def self.authenticate(account_id, email, pass)
    u = self.find(:first, :conditions => ["account_id = ? and email = ?", account_id, email])
    return nil if u.nil?
    self.find(:first, :conditions => ["account_id = ? and email = ? AND salted_password = ?", account_id, email, salted_password(u.salt, hashed(pass))])
  end

  def self.authenticate_by_token(account_id, id, token)
    # Allow logins for deleted accounts, but only via this method (and
    # not the regular authenticate call)
    u = self.find(:first, :conditions => ["account_id = ? and id = ? AND security_token = ?", account_id, id, token])
    return nil if u.nil? or u.token_expired?
    u
  end

  def token_expired?
    self.security_token and self.token_expiry and (Time.now > self.token_expiry)
  end

  def clear_token
    write_attribute(:security_token, nil)
    write_attribute(:token_expiry, nil)
    update_without_callbacks
  end

  def generate_security_token(seconds = nil)
    if not seconds.nil? or self.security_token.nil? or self.token_expiry.nil? or
        (Time.now.to_i + token_lifetime / 2) >= self.token_expiry.to_i
      return new_security_token(seconds)
    else
      return self.security_token
    end
  end

  def change_password(pass, confirm = nil)
    self.password = pass
    self.password_confirmation = confirm.nil? ? pass : confirm
    @new_password = true
  end

protected

  attr_accessor :password, :password_confirmation

  def password_validations?
    @new_password || (self.id.nil? && self.email)
  end

  def self.hashed(str)
    return Digest::SHA1.hexdigest("sdoaufhy7--#{str}--")[0..39]
  end

  after_save '@new_password = false'

  after_validation :crypt_password

  def crypt_password
    if @new_password || self.id.nil?
      write_attribute("salt", self.class.hashed("salt-#{Time.now}"))
      write_attribute("salted_password", self.class.salted_password(salt, self.class.hashed(@password)))
    end
  end

 def new_security_token(seconds = nil)
    write_attribute('security_token', self.class.hashed(self.salted_password + Time.now.to_i.to_s + rand.to_s))
    write_attribute('token_expiry', Time.at(Time.now.to_i + token_lifetime(seconds)))
    update_without_callbacks
    return self.security_token
  end

  def token_lifetime(seconds = nil)
    if seconds.nil?
      24 * 60 * 60
    else
      seconds
    end
  end

   def self.salted_password(salt, hashed_password)
    hashed(salt + hashed_password)
  end
end
