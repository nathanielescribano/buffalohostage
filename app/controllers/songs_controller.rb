class SongsController < ApplicationController
  include AWS::S3 
  require './app/helpers/sessions_helper.rb' # change this? 
  BUCKET = 'buffalo_hostage'
  before_filter :get_user
  before_action :is_song_owner?, only: [:new, :edit, :update, :delete]

  def get_user
    @user = User.find(params[:user_id]) 
    # how to use current_user from sessions_helper?? 
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def index
    is_band?(@current_user) ? @songs = @user.songs : @songs = @user.songs.public
    if @songs.count >= 1
      @url ||= ''
      @any_songs = true
      @uploaded_songs = uploaded?(@user, @songs)
    else 
      @any_song = false 
    end
  end

  def new
    @song = @user.songs.new
  end

  def edit
    @song = Song.find(params[:id])
  end

  def create
    @song = @user.songs.new(song_params)
    if @song.save
      flash[:success] = "Song added."
      redirect_to user_path(@current_user) # Change this later 
    else
      render 'new'
    end
  end

  def update
    @song = Song.find(params[:id])
    song_name = format_file(@song.title)
    unless S3Object.exists? song_name, BUCKET
      begin
        S3Object.store(song_name, params[:mp3file].read, BUCKET, 
                                                     access: :public_read)
        redirect_to user_path(@current_user), notice: "Uploaded " + @song.title
      rescue   
        flash[:error] = "Error..."
        redirect_to edit_user_song_path(@current_user, @song)
      end 
    else
      redirect_to user_path(@current_user), notice: "Upload already exists."
    end
  end

  def destroy
    @song = Song.find(params[:id])
    song_name = format_file(@song.title)
    if S3Object.exists? song_name, BUCKET
      S3Object.delete song_name, BUCKET
      @song.destroy
      flash[:success] = "Deleted uploaded track." 
      redirect_to user_path(@current_user)
    else
      @song.destroy
      redirect_to user_path(@current_user), notice: "Deleted."
    end
  end

  private

    def format_file(name)
      '/' + @current_user.name.to_s + '/' + name.gsub(/\s/, '_') + '.mp3'
    end

    def song_params
      params.require(:song).permit(:title, :privacy) 
    end
 
    def is_band?(user)
      User.band.include? user
    end

    def is_song_owner?
      unless is_band?(@current_user) and @current_user == @user
        redirect_to bands_url, notice: "Access not granted."
      end
    end

    def uploaded?(user, songs)
      bucket = Bucket.find(BUCKET)
      find_str = user.name + '/'
      uploaded_songs = bucket.objects(user.name.gsub(/\s/, '+'))[1..-1]
      uploaded_songs.map! do |s|
        s = s.key.gsub(/#{find_str}/, '')
      end
      return uploaded_songs 
    end 

end
