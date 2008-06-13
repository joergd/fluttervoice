require File.dirname(__FILE__) + '/../../test_helper'

class Adm1n::ManualInterventionsControllerTest < ActionController::TestCase
  fixtures :accounts, :people, :plans
  def setup
    super
    @manual_intervention = ManualIntervention.create!(:account => @woodstock_account, :description => "Help me")
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:manual_interventions)
  end

  def test_should_show_manual_intervention
    get :show, :id => @manual_intervention.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => @manual_intervention.id
    assert_response :success
  end

  def test_should_update_manual_intervention
    put :update, :id => @manual_intervention.id, :manual_intervention => { }
    assert_redirected_to adm1n_manual_interventions_path
  end

  def test_should_destroy_manual_intervention
    assert_difference('ManualIntervention.count', -1) do
      delete :destroy, :id => @manual_intervention.id
    end

    assert_redirected_to adm1n_manual_interventions_path
  end
  
  def test_should_set_complete
    @manual_intervention.update_attribute :completed_at, nil
    post :complete, :id => @manual_intervention.id
    @manual_intervention.reload
    assert_not_nil @manual_intervention.completed_at
  end

  
end
