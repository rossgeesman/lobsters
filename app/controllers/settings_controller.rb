class SettingsController < ApplicationController
  before_filter :require_logged_in_user

  def index
    @title = t('controllers.settings.settings_title')

    @edit_user = @user.dup
  end

  def delete_account
    if @user.try(:authenticate, params[:user][:password].to_s)
      @user.delete!
      reset_session
      flash[:success] = t('controllers.settings.account_deleted')
      return redirect_to "/"
    end

    flash[:error] = t('controllers.settings.password_unverified')
    return redirect_to settings_path
  end

  def update
    @edit_user = @user.clone

    if @edit_user.update_attributes(user_params)
      flash.now[:success] = t('controllers.settings.update_success')
      @user = @edit_user
    end

    render :action => "index"
  end

private

  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :about,
      :email_replies, :email_messages, :email_mentions,
      :pushover_replies, :pushover_messages, :pushover_mentions,
      :pushover_user_key, :pushover_device, :pushover_sound,
      :mailing_list_mode
    )
  end
end
