class UsersController < ApplicationController
  def show
    @showing_user = User.where(:username => params[:username]).first!
    @title = t('controllers.users.showing_user_title', user: @showing_user.username )
  end

  def tree
    @title = t('controllers.users.user_title')

    if params[:by].to_s == "karma"
      @users = User.order("karma DESC, id ASC").to_a
      @user_count = @users.length
      render :action => "list"
    else
      users = User.order("id DESC").to_a
      @user_count = users.length
      @users_by_parent = users.group_by(&:invited_by_user_id)
    end
  end

  def invite
    @title = t('controllers.users.user_invitation')
  end
end
