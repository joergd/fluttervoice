require File.dirname(__FILE__) + '/../test_helper'
require 'preferences_controller'

# Re-raise errors caught by the controller.
class PreferencesController; def rescue_action(e) raise e end; end

class PreferencesControllerTest < Test::Unit::TestCase
  fixtures :preferences, :accounts, :people, :document_templates

  def setup
    @controller = PreferencesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
    login # in test_helper.rb
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:preference)
    assert_not_nil assigns(:taxes)
    assert_not_nil assigns(:terms)
    assert_not_nil assigns(:currencies)
  end

  def test_index_with_non_primary
    login :kyle
    get :index
    assert_redirected_to :controller => 'account', :action => 'index'
    assert_equal 'You need to be the main user for the account to change the settings.', flash[:notice]
  end

  def test_index_with_success
    post   :index,
          :preference => {  :currency_id => "ZAR",
                            :terms => "30 days",
                            :tax_system => "VAT",
                            :tax_percentage => 14 }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

  def test_index_with_failure
    post   :index,
          :preference => {  :currency_id => "ZAR",
                            :terms => "30 days",
                            :tax_system => "VAT",
                            :tax_percentage => 100 }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert_equal "must be in the format x.xx", assigns(:preference).errors.on(:tax_percentage)
  end

  def test_templates
    get :templates
    assert_response :success
    assert_not_nil assigns(:preference)
    assert_not_nil assigns(:templates)
  end

  def test_templates_with_non_primary
    login :kyle
    get :templates
    assert_redirected_to :controller => 'account', :action => 'index'
    assert_equal 'You need to be the main user for the account to change the settings.', flash[:notice]
  end

  def test_templates_with_success
    post   :templates,
          :preference => { :document_template_id => @classic_template.id }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

  def test_templates_with_failure
    post   :templates,
          :preference => { :document_template_id => "" }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert_equal "can't be blank", assigns(:preference).errors.on(:document_template_id)
  end

  def test_thankyous
    get :thankyous
    assert_response :success
    assert_not_nil assigns(:preference)
  end

  def test_thankyous_with_non_primary
    login :kyle
    get :thankyous
    assert_redirected_to :controller => 'account', :action => 'index'
    assert_equal 'You need to be the main user for the account to change the settings.', flash[:notice]
  end

  def test_thankyous_with_success
    post   :thankyous,
          :preference => { :thankyou_message => 'Howdy' }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

  def test_thankyous_with_empty_messsage
    post   :thankyous,
          :preference => { :thankyou_message => '' }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

  def test_thankyous
    get :thankyous
    assert_response :success
    assert_not_nil assigns(:preference)
  end

  def test_thankyous_with_non_primary
    login :kyle
    get :thankyous
    assert_redirected_to :controller => 'account', :action => 'index'
    assert_equal 'You need to be the main user for the account to change the settings.', flash[:notice]
  end

  def test_thankyous_with_success
    post   :thankyous,
          :preference => { :thankyou_message => 'Howdy' }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

  def test_thankyous_with_empty_messsage
    post   :thankyous,
          :preference => { :thankyou_message => '' }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end
  def test_invoicenotes
    get :invoicenotes
    assert_response :success
    assert_not_nil assigns(:preference)
  end

  def test_invoicenotes_with_non_primary
    login :kyle
    get :invoicenotes
    assert_redirected_to :controller => 'account', :action => 'index'
    assert_equal 'You need to be the main user for the account to change the settings.', flash[:notice]
  end

  def test_invoicenotes_with_success
    post   :invoicenotes,
          :preference => { :invoice_notes => 'Howdy' }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

  def test_invoicenotes_with_empty_messsage
    post   :invoicenotes,
          :preference => { :invoice_notes => '' }
    assert_response :success
    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

#  def test_a_file_upload
#    num_images = Image.count
#    num_binaries = Binary.count
#    me = uploaded_jpeg("#{File.expand_path(RAILS_ROOT)}/test/fixtures/me.jpg")
#    post :upload_logo, :image_file => me
#    assert_redirected_to :action => 'index'
#    assert_equal num_images + 1, Image.count
#    assert_equal num_binaries + 1, Binary.count
#  end

  def test_post_upload_logo
    post :upload_logo
    assert_redirected_to :action => 'index'
  end

  def test_get_delete_logo
    get :delete_logo
    assert_redirected_to :action => 'index'
  end

private

  # get us an object that represents an uploaded file
  def uploaded_file(path, content_type="application/octet-stream", filename=nil)
    filename ||= File.basename(path)
    t = Tempfile.new(filename)
    FileUtils.copy_file(path, t.path)
    (class << t; self; end;).class_eval do
      alias local_path path
      define_method(:original_filename) { filename }
      define_method(:content_type) { content_type }
    end
    return t
  end

  # a JPEG helper
  def uploaded_jpeg(path, filename=nil)
    uploaded_file(path, 'image/jpeg', filename)
  end

  # a GIF helper
  def uploaded_gif(path, filename=nil)
    uploaded_file(path, 'image/gif', filename)
  end

end
