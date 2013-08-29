class Song < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true, length: { maximum: 20 }, uniqueness: true 
end
