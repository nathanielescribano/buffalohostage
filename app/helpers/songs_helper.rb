module SongsHelper

  # Format the rendering of the song titles
  def format_song(song, user)
    if is_band?(user)
      "Title: " + song.title + " is private?: " + song.privacy.to_s.titleize
    else
      "Title: " + song.title
    end
  end

end
