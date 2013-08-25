class SongsController < ApplicationController
  include AWS::S3 
  BUCKET = 'eastelk'

  def index
    @songs = Song.all
    @a_songs = AWS::S3::Bucket.find(BUCKET).objects
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
end
