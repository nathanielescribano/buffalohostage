module UsersHelper

  def is_band?(user)
    User.band.include? user
  end

end
