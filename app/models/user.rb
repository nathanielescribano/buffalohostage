class User < ActiveRecord::Base

  before_save do 
    self.email = email.downcase
    self.name = name.downcase
  end

  before_save :create_remember_token
 
  has_many :songs
   
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, 
                     uniqueness: true 
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL }, 
                     uniqueness: true
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true 

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
