class UsersController < ApplicationController
  include AWS::S3

  before_action :signed_in_user, only: [:show]

  def index
    @bands = User.band
  end

  def show
    # Limit this to be only current_user viewable 
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
      create_bucket(@user) if User.band.include? @user
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

    def signed_in_user 
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def create_bucket(user)
      # Amazon names cannot have spaces
      bucket_name = user.name.gsub(/\s/, '_')
      Bucket.create(bucket_name) unless Service.buckets.include? bucket_name
    end

end
