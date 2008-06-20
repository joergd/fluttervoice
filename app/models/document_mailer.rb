class DocumentMailer < ActionMailer::Base

  def invoice(to, from, cc, account, invoice, invoice_html, summary_url, message, app_config, sent_at = Time.now)
    @subject    = "Invoice #{invoice.number} from #{account.name}"
    @body        = { :account => account, :invoice => invoice, :invoice_html => invoice_html, :summary_url => summary_url, :message => message, :app_config => app_config }
    @recipients = to
    @from       = from
    @cc          = cc
    @sent_on    = sent_at
    @headers    = {}
  end

  def reminder(to, from, cc, account, invoice, invoice_html, summary_url, message, app_config, sent_at = Time.now)
    @subject    = "Reminder for Invoice #{invoice.number} from #{account.name}"
    @body        = { :account => account, :invoice => invoice, :invoice_html => invoice_html, :summary_url => summary_url, :message => message, :app_config => app_config }
    @recipients = to
    @from       = from
    @cc          = cc
    @sent_on    = sent_at
    @headers    = {}
  end

  def thankyou(to, from, cc, account, invoice, summary_url, message, app_config, sent_at = Time.now)
    @subject    = "Thankyou for Invoice #{invoice.number} from #{account.name}"
    @body        = { :account => account, :invoice => invoice, :summary_url => summary_url, :message => message, :app_config => app_config }
    @recipients = to
    @from       = from
    @cc          = cc
    @sent_on    = sent_at
    @headers    = {}
  end

end
