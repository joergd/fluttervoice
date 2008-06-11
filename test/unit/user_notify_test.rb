require File.dirname(__FILE__) + '/../test_helper'
require 'user_notify'

class UserNotifyTest < Test::Unit::TestCase
  fixtures :accounts, :people

  def setup
    @account = @woodstock_account
    @user = @joerg
  end

  def test_forgot_password
    email = UserNotify.create_forgot_password('',
                                          @user,
                                          @account,
                                          { 'app_name' => 'Fluttervoice', 'domain' => 'fluttervoice.com' })
    assert_equal "multipart/alternative", email.content_type
    assert_equal("[Fluttervoice] Forgotten password", email.subject)
    assert_equal(@joerg.email, email.to[0])
    assert_match(/Dear joerg/, email.body)
    assert_match(/forgotten/, email.body)
  end

end
