class UsersController < ApplicationController

  skip_before_action :require_login,   :only => [ :new, :create ]
  before_action :require_current_user, :only => [ :edit, :update, :destroy ]
  before_create :generate_token


  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      flash[:success] = "Created new user!"
      redirect_to @user
    else
      flash.now[:error] = "Failed to Create User!"
      render :new
    end
  end

  def update
    if current_user.update(user_params)  # <<<<<
      flash[:success] = "Successfully updated your profile"
      redirect_to current_user
    else
      flash.now[:failure] = "Failed to update your profile"
      render :edit
    end
  end

  def destroy
    if current_user.destroy
      sign_out( current_user )
      flash[:notice] = "Destroyed successfully."
      redirect_to root_path
    else
      render :edit
    end
  end


  def generate_token
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64
    end while User.exists?(:auth_token => self[:auth_token])
  end

  def regenerate_auth_token
    self.auth_token = nil
    generate_token
    save!
  end


  private
  def user_params
    params.require(:user).permit( :first_name, :last_name, :email, :password, :password_confirmation )
  end

end
