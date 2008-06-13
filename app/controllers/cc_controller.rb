class CcController < ApplicationController
  def callback_approved
    if params[:pam] == @app_config['pam']
      account = Account.find(params[:m_1])
      plan = Plan.find(params[:m_2])
      user = User.find_by_id(params[:m_3])
      CreditCardTransaction.create!(:account => account,
                                    :plan => plan,
                                    :user => user,
                                    :subdomain => account.subdomain,
                                    :reference => params[:p2],
                                    :response => params[:p3],
                                    :cc_name => params[:p5],
                                    :amount => params[:p6],
                                    :cc_type => params[:p7],
                                    :description => params[:p8],
                                    :cc_email => params[:p9],
                                    :cc_expiry => params[:p11],
                                    :cc_masked_number => params["MaskedCardNumber"],
                                    :cc_card_holder_ip_addr => params["CardHolderIpAddr"]
                                    )
      if account.plan != plan
        account.plan = plan
        account.save!
      end
      render :text => "Approved", :status => 200
    else
      render :text => "Wrong PAM", :status => 403
    end
  end

  def callback_not_approved
    if params[:pam] == @app_config['pam']
      account = Account.find(params[:m_1])
      plan = Plan.find(params[:m_2])
      user = User.find_by_id(params[:m_3])
      CreditCardTransaction.create!(:account => account,
                                    :plan => plan,
                                    :user => user,
                                    :subdomain => account.subdomain,
                                    :reference => params[:p2],
                                    :response => params[:p3],
                                    :cc_name => params[:p5],
                                    :amount => params[:p6],
                                    :cc_type => params[:p7],
                                    :description => params[:p8],
                                    :cc_email => params[:p9])
      ManualIntervention.create(:account => account,
                                :description => "Credit card payment not approved. Investigate?")
      render :text => "Not approved", :status => 200
    else
      render :text => "Wrong PAM", :status => 403
    end
  end
  
end
