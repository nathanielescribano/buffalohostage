class Song < ActiveRecord::Base
  belongs_to :user
  scope :public, -> { where(privacy: false) }

  validates :title, presence: true, length: { maximum: 20 }, uniqueness: true 

  def public?
    !privacy
  end
end
