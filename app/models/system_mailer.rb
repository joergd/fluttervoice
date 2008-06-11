class SystemMailer < ActionMailer::Base

  helper ActionView::Helpers::UrlHelper

  def welcome_free(options)
    account = options[:account]
    options[:subject] = "Welcome to Fluttervoice"
    options[:recipients] = account.primary_user.email
    options[:body] = { :account => account, :base_url => options[:base_url] }
    setup(options)
  end
  
  def welcome_paid(options)
    account = options[:account]
    options[:subject] = "Welcome to Fluttervoice #{account.plan.name}"
    options[:recipients] = account.primary_user.email
    options[:body] = { :account => account, :base_url => options[:base_url] }
    setup(options)
  end

  def invoice(options)
    account = options[:account]
    options[:subject] = "Subscription confirmation to Fluttervoice #{account.plan.name}"
    options[:recipients] = account.primary_user.email
    options[:body] = { :account => account, :order_number => options[:order_number], :amount => options[:amount], :home_url => options[:home_url] }
    setup(options)
  end
  
  def downgrade_to_free(options)
    account = options[:account]
    options[:subject] = "Subscription confirmation to Fluttervoice #{account.plan.name}"
    options[:recipients] = account.primary_user.email
    options[:body] = { :account => account, :home_url => options[:home_url] }
    setup(options)
  end
  
private

  def setup(options)
    @recipients = options[:recipients] || "joergd@pobox.com"
    @from = options[:from] || ""
    @cc = options[:cc] || ""
    @bcc = options[:bcc] || ""
    @subject = "[Fluttervoice] " + (options[:subject] || "")
    @body = options[:body] || {}
    @headers = options[:headers] || {}
    @charset = options[:charset] || "utf-8"
  end

end
