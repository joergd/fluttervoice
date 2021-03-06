class CcController < ApplicationController
  def callback_approved
    if params[:pam] == @app_config['pam']
      account = Account.find(params[:m_1])
      plan = Plan.find(params[:m_2])
      user = User.find_by_id(params[:m_3])
      expiry = params[:p11].blank? ? "" : params[:p11][2..3] + params[:p11][0..1]
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
                                    :cc_expiry => expiry,
                                    :cc_masked_number => params["MaskedCardNumber"],
                                    :cc_card_holder_ip_addr => params["CardHolderIpAddr"],
                                    :terminal => params[:p1]
                                    )
      if account.plan != plan
        oldpaidplan = account.plan
        account.plan = plan
        account.save!
        SystemMailer.deliver_welcome_paid(:from => "#{@app_config['system_email']}", :account => account, :oldpaidplan => oldpaidplan, :base_url => base_url) rescue true
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
      expiry = params[:p11].blank? ? "" : params[:p11][2..3] + params[:p11][0..1]
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
                                    :cc_expiry => expiry,
                                    :terminal => params[:p1]
                                    )
      ManualIntervention.create(:account => account,
                                :description => "Credit card payment not approved. Investigate?")
      render :text => "Not approved", :status => 200
    else
      render :text => "Wrong PAM", :status => 403
    end
  end
  
end
