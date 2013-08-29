class UsersController < ApplicationController

  def index
    @bands = User.band
  end

  def show
    @user = User.find(params[:id])
    @user_songs = @user.songs
    # way to remove this redundancy?? 
    if @user_songs.count >= 1
      @any_songs = true
    else
      @any_songs = false 
    end
  end

  def new 
    @user = User.new
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome."
      redirect_to @user
    else
      render 'new'
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                         :password_confirmation)
    end

end
