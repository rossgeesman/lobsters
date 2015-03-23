class SignupController < ApplicationController
  before_filter :require_logged_in_user, :only => :invite

  def index
    if @user
      flash[:error] = t('controllers.signup.already_signedup')
      return redirect_to "/"
    end

    @title = t('controllers.signup.signup_title')
  end

  def invited
    if @user
      flash[:error] = t('controllers.signup.already_signedup')
      return redirect_to "/"
    end

    if !(@invitation = Invitation.where(:code => params[:invitation_code].to_s).first)
      flash[:error] = t('controllers.signup.invalid_invitation')
      return redirect_to "/signup"
    end

    @title = t('controllers.signup.signup_title')

    @new_user = User.new
    @new_user.email = @invitation.email

    render :action => "invited"
  end

  def signup
    if !(@invitation = Invitation.where(:code => params[:invitation_code].to_s).first)
      flash[:error] = t('controllers.signup.invalid_invitation')
      return redirect_to "/signup"
    end

    @title = t('controllers.signup.signup_title')

    @new_user = User.new(user_params)
    @new_user.invited_by_user_id = @invitation.user_id

    if @new_user.save
      @invitation.destroy
      session[:u] = @new_user.session_token
      flash[:success] = t('controllers.signup.welcome_message', site: Rails.application.name, user: @new_user.username )

      Countinual.count!("#{Rails.application.shortname}.users.created", "+1")

      return redirect_to "/signup/invite"
    else
      render :action => "invited"
    end
  end

private

  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :about,
    )
  end
end
