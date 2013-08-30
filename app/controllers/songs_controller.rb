class SongsController < ApplicationController
  include AWS::S3 
  require './app/helpers/sessions_helper.rb' # change this? 
  BUCKET = 'eastelk'
  before_filter :get_user
  before_action :is_song_owner?, only: [:new, :upload, :delete]

  def get_user
    @user = User.find(params[:user_id]) 
    # how to use current_user from sessions_helper?? 
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def index
    is_band?(@current_user) ? @songs = @user.songs : @songs = @user.songs.public
    if @songs.count >= 1
      @any_songs = true
      # @a_songs = AWS::S3::Bucket.find(BUCKET).objects
    else 
      @any_song = false 
    end
  end

  def new
    @song = @user.songs.new
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

  def upload
    begin 
      song_name = sanitize_filename(params[:mp3file].original_filename)
      Song.save(title: song_name, privacy: false)
      AWS::S3::S3Object.store(song_name, params[:mp3file].read, 
                                          BUCKET, :access => :public_read)
      redirect_to songs_path
    rescue
      render :text => "Couldn't upload"
    end
  end

  def delete
    if params[:song]
      AWS::S3::S3Object.find(params[:song], BUCKET).delete
      redirect_to songs_path
    else
      render :text => "no song found to delete."
    end
  end

  private

    def sanitize_filename(file_name)
      just_filename = File.basename(file_name)
      just_filename.sub(/[^\w\.\-]/, '_')
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

end
