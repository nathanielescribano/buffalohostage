class StaticPagesController < ApplicationController

  def home
    @newest_user = User.last
  end

end
