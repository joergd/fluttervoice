class DocumentMailer < ActionMailer::Base

  def invoice(to, from, cc, account, document, document_html, summary_url, message, app_config, sent_at = Time.now)
    @subject    = "Invoice #{document.number} from #{account.name}"
    @body        = { :account => account, :document => document, :document_html => document_html, :summary_url => summary_url, :message => message, :app_config => app_config }
    @recipients = to
    @from       = from
    @cc          = cc
    @sent_on    = sent_at
    @headers    = {}
  end

  def reminder(to, from, cc, account, document, document_html, summary_url, message, app_config, sent_at = Time.now)
    @subject    = "Reminder for Invoice #{document.number} from #{account.name}"
    @body        = { :account => account, :document => document, :document_html => document_html, :summary_url => summary_url, :message => message, :app_config => app_config }
    @recipients = to
    @from       = from
    @cc          = cc
    @sent_on    = sent_at
    @headers    = {}
  end

  def thankyou(to, from, cc, account, document, summary_url, message, app_config, sent_at = Time.now)
    @subject    = "Thankyou for Invoice #{document.number} from #{account.name}"
    @body        = { :account => account, :document => document, :summary_url => summary_url, :message => message, :app_config => app_config }
    @recipients = to
    @from       = from
    @cc          = cc
    @sent_on    = sent_at
    @headers    = {}
  end

  def quote(to, from, cc, account, document, document_html, summary_url, message, app_config, sent_at = Time.now)
    @subject    = "Quote #{document.number} from #{account.name}"
    @body        = { :account => account, :document => document, :document_html => document_html, :summary_url => summary_url, :message => message, :app_config => app_config }
    @recipients = to
    @from       = from
    @cc          = cc
    @sent_on    = sent_at
    @headers    = {}
  end

end
