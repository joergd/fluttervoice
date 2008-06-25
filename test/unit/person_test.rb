require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  fixtures :accounts, :people, :clients

  def setup
    @person = Person.find(@joerg.id)
  end

  def test_types
    user = Person.find(@joerg.id)
    assert_kind_of User,  user

    contact = Person.find(@jonny.id)
    assert_kind_of Contact, contact
  end

  def test_auth
    assert_equal  @joerg, User.authenticate(@woodstock_account.id, "joergd@pobox.com", "atest")
    assert_nil User.authenticate(@woodstock_account.id, "nonexisting@test.com", "atest")
    assert_nil User.authenticate(@woodstock_account.id, "sarita@test.com", "alongtest")
  end

  def test_passwordchange
    @sarita.change_password("differentpassword")
    @sarita.save
    assert_equal @sarita, User.authenticate(@painting_account.id, "sarita@test.com", "differentpassword")
    assert_nil User.authenticate(@painting_account.id, "sarita@test.com", "alongtest")
    @sarita.change_password("alongtest")
    @sarita.save
    assert_equal @sarita, User.authenticate(@painting_account.id, "sarita@test.com", "alongtest")
    assert_nil User.authenticate(@painting_account.id, "sarita@test.com", "differentpassword")
  end

  def test_disallowed_passwords
    @person.change_password("tiny")
    assert !@person.save
    assert @person.errors.invalid?('password')

    @person.change_password("hugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehuge")
    assert !@person.save
    assert @person.errors.invalid?('password')

    @person.change_password("joergs_secure_password")
    assert @person.save
    assert @person.errors.empty?
  end

  def test_collision
    @person.email = @kyle.email
    assert !@person.save

    @person.email = @sarita.email
    assert @person.save
  end

  def test_bad_email
    @person.email = "wrong.email"
    assert !@person.save
    assert @person.errors.invalid?('email')
  end

	def test_email_with_ampersand
    @person.email = "stan&dad@gmail.com"
    assert @person.save
	end
	
  def test_create_contact
    p = Contact.new
    assert !p.save

    p.email = "newperson@test.com"
    assert !p.save

    p.firstname = "newperson"
    assert !p.save

    p.lastname = "newperson"
    assert p.save

    # p.client_id = @edh.id
    # p.account_id = @woodstock_account.id
    # assert p.save
  end

  def test_create_user
    p = User.new
    p.account_id = @woodstock_account.id
    assert !p.save

    p.email = "newperson@test.com"
    assert !p.save

    p.firstname = "newperson"
    assert !p.save

    p.lastname = "newperson"
    assert !p.save

    p.change_password("newperson_secure_password")
    assert p.save
  end

  def test_jump_token_login
    assert_equal @joerg, User.authenticate_by_jump_token(@woodstock_account.id, @joerg.id, @joerg.jump_token)
    assert_not_equal @joerg, User.authenticate_by_jump_token(@painting_account.id, @joerg.id, @joerg.jump_token)
    assert_not_equal @joerg, User.authenticate_by_jump_token(@woodstock_account.id, @sarita.id, @joerg.jump_token)
    assert_not_equal @joerg, User.authenticate_by_jump_token(@woodstock_account.id, @joerg.id, nil)
  end

end
