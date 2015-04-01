class EmailMessage < ActionMailer::Base
  def notify(message, user)
    @message = message
    @user = user

    mail(
      :to => user.email,
      :subject => "[#{Rails.application.name}] Private Message from " <<
        "#{message.author.username}: #{message.subject}"
    )
  end
end
