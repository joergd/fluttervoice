require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < Test::Unit::TestCase
  fixtures :accounts, :clients, :plans, :documents, :people, :preferences

  def setup
    @account = Account.find(@woodstock_account.id)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Account,  @account
  end

  def test_validate_duplicate_subdomain
    assert @account.save

    assert_equal @woodstock_account.subdomain, @account.subdomain
    @account.subdomain = @painting_account.subdomain
    assert !@account.save
    assert_equal 1, @account.errors.count
    assert_equal "already taken", @account.errors.on(:subdomain)
  end

  def test_validate_invalid_subdomain
    @account.subdomain = 'a'
    assert !@account.save
    assert_equal 1, @account.errors.count
    assert_equal "is too short (minimum is 2 characters)", @account.errors.on(:subdomain)

    @account.subdomain = 'sflhjsdflsdhfsdlkfjlsdjfjsldfjsdjflsdljflsdjflsdljflsdjfljdslflsdjflsjfa'
    assert !@account.save
    assert_equal 1, @account.errors.count
    assert_equal "is too long (maximum is 30 characters)", @account.errors.on(:subdomain)

    @account.subdomain = "in,valid"
    assert !@account.save
    assert_equal 1, @account.errors.count
    assert_equal "only lowercase letters and digits are allowed", @account.errors.on(:subdomain)
  end

  def test_validate_reserved_subdomain
    @account.subdomain = 'mail'
    assert !@account.save
    assert_equal "mail is a reserved word", @account.errors[:subdomain]
  end
  
  def test_validate_create
    a = Account.new
    assert !a.save

    a.name = 'Another Account'
    assert !a.save

    a.subdomain = 'another'
    assert a.save
    assert_equal a.effective_date, Date.today
  end

  def test_days_left_in_cycle
    @woodstock_account.effective_date = Date.new(2004, 12, 15)
    assert @woodstock_account.days_left_in_cycle <= 31

    @woodstock_account.effective_date = Date.today
    assert @woodstock_account.days_left_in_cycle >= 28 && @woodstock_account.days_left_in_cycle <= 31

    @woodstock_account.effective_date = Date.today - 1
    assert @woodstock_account.days_left_in_cycle >= 27 && @woodstock_account.days_left_in_cycle <= 31

    @woodstock_account.effective_date = Date.today + 1
    assert @woodstock_account.days_left_in_cycle == 1
  end

  def test_next_cycle_date
    @woodstock_account.effective_date = Date.new(2005, 9, 18)

    dt = Date.new(2005, 10, 1)
    assert_equal Date.new(2005, 10, 18), @woodstock_account.next_cycle_date(dt)

    dt = Date.new(2005, 10, 20)
    assert_equal Date.new(2005, 11, 18), @woodstock_account.next_cycle_date(dt)

    dt = Date.new(2005, 12, 20)
    assert_equal Date.new(2006, 1, 18), @woodstock_account.next_cycle_date(dt)

    dt = Date.new(2005, 9, 18)
    assert_equal Date.new(2005, 10, 18), @woodstock_account.next_cycle_date(dt)

    @woodstock_account.effective_date = Date.new(2005, 8, 31)

    dt = Date.new(2005, 11, 20)
    assert_equal Date.new(2005, 11, 30), @woodstock_account.next_cycle_date(dt)

    dt = Date.new(2005, 10, 20)
    assert_equal Date.new(2005, 10, 31), @woodstock_account.next_cycle_date(dt)
  end

  def test_current_cycle_date
    @woodstock_account.effective_date = Date.new(2005, 9, 18)

    dt = Date.new(2005, 10, 1)
    assert_equal Date.new(2005, 9, 18), @woodstock_account.current_cycle_date(dt)

    dt = Date.new(2005, 10, 20)
    assert_equal Date.new(2005, 10, 18), @woodstock_account.current_cycle_date(dt)

    dt = Date.new(2006, 1, 20)
    assert_equal Date.new(2006, 1, 18), @woodstock_account.current_cycle_date(dt)

    dt = Date.new(2006, 1, 1)
    assert_equal Date.new(2005, 12, 18), @woodstock_account.current_cycle_date(dt)

    dt = Date.new(2005, 9, 18)
    assert_equal Date.new(2005, 9, 18), @woodstock_account.current_cycle_date(dt)

    @woodstock_account.effective_date = Date.new(2005, 8, 31)

    dt = Date.new(2005, 11, 20)
    assert_equal Date.new(2005, 10, 31), @woodstock_account.current_cycle_date(dt)

    dt = Date.new(2005, 10, 20)
    assert_equal Date.new(2005, 9, 30), @woodstock_account.current_cycle_date(dt)
  end

  def test_user_limits_free
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    assert @woodstock_account.user_limit_reached?
  end

  def test_user_limits_heavy
    @woodstock_account.plan_id = 3
    @woodstock_account.save
    assert !@woodstock_account.user_limit_reached?
  end

  def test_user_limits_ultimate
    @woodstock_account.plan_id = 4 # unlimited
    @woodstock_account.save
    assert !@woodstock_account.user_limit_reached?
  end

  def test_client_limits_free
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    assert_equal 2, @woodstock_account.clients.count
    assert @woodstock_account.client_limit_reached?
  end

  def test_client_limits_heavy
    @woodstock_account.plan_id = 2
    @woodstock_account.save
    assert !@woodstock_account.client_limit_reached?
  end

  def test_client_limits_ultimate
    @woodstock_account.plan_id = 4 # unlimited
    @woodstock_account.save
    assert !@woodstock_account.client_limit_reached?
  end

  def test_invoice_limits_free
    @woodstock_account.plan_id = 1    
    @woodstock_account.save
    @woodstock_account.update_attribute :effective_date, Date.today - 10 # As in fixtures
    assert_equal 4, @woodstock_account.invoices_sent_in_current_cycle
    assert @woodstock_account.invoice_limit_reached?
  end

  def test_invoice_limits_heavy
    @woodstock_account.plan_id = 2
    @woodstock_account.save
    assert !@woodstock_account.invoice_limit_reached?
  end

  def test_plan_change
    assert @woodstock_account.update_attribute(:plan_id, Plan::FREE)
      assert_difference('ManualIntervention.count', 0) do
        assert_difference('AuditChangePlan.count') do
        @woodstock_account.plan = Plan.find(Plan::LITE)
        @woodstock_account.save
      end
    end
    @woodstock_account.reload
    assert_equal Date.today, @woodstock_account.effective_date
    assert_difference('ManualIntervention.count') do
      assert_difference('AuditChangePlan.count') do
        @woodstock_account.plan = Plan.find(Plan::HARDCORE)
        @woodstock_account.save
      end
    end
    @woodstock_account.reload
    assert_equal Date.today, @woodstock_account.effective_date
  end
  
  def test_destroy_account
    assert_difference('ManualIntervention.count') do
      @woodstock_account.destroy
    end
  end
  
end
