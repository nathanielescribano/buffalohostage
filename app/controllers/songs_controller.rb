class SongsController < ApplicationController
  include AWS::S3 
  BUCKET = 'eastelk'
  before_filter :get_user

  def get_user
    @user = User.find(params[:user_id]) # what about current user?
  end

  def index
    if @user.songs.count >= 1
      @any_songs = true
      @my_songs = @user.songs
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
      redirect_to root_path # Change this later 
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
 
end
