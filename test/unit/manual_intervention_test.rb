require File.dirname(__FILE__) + '/../test_helper'

class ManualInterventionTest < ActiveSupport::TestCase
  fixtures :accounts

  def test_create_alert
    @emails = ActionMailer::Base.deliveries
    @emails.clear

    assert ManualIntervention.create!(:account => @woodstock_account)
    
    email = @emails.first
    assert_match /Alert/, email.subject
    
  end
end
