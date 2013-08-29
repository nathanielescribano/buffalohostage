module SongsHelper

  # Format the rendering of the song titles
  def format_song(song)
    "Title: " + song.title + " is private?: " + song.privacy.to_s.titleize
  end

end
