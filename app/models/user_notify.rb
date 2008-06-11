class UserNotify < ActionMailer::Base

  def forgot_password(url, user, account, app_config)
    setup_email(user, app_config)

    @subject    = "[#{app_config['app_name']}] Forgotten password"
    @body       = { :url => url, :user => user, :account => account, :app_config => app_config }
  end

private

  def setup_email(user, app_config)
    @recipients = user.email
    @from       = app_config['system_email']
    @sent_on    = Time.now
    @headers['Content-Type'] = "text/plain; charset=utf-8; format=flowed"
  end

end
