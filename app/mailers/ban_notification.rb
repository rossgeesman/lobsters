class BanNotification < ActionMailer::Base
  def notify(user, banner, reason)
    @banner = banner
    @reason = reason

    mail(
      :from => "#{@banner.username} <#{@banner.email}>",
      :to => user.email,
      :subject => "[#{Rails.application.name}] You have been banned"
    )
  end
end
