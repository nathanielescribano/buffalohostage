module SongsHelper

  def url_for_song(user, song)
    url = "https://s3.amazonaws.com/buffalo_hostage/"
    url = url + user.name.gsub(/\s/, '+') + '/'
    url = url + song.title + '.mp3'
  end

end
