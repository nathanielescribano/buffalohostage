class User < ActiveRecord::Base
  has_many :songs 

  BANDS = ["east elk", "haike", "nathaniel", "averoteriz", "wmitchell"] 

  before_validation :format_user
  before_save :make_band, :create_remember_token

  scope :band, -> { where(band: true) }

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, 
                     uniqueness: true 
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL }, 
                     uniqueness: true
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true 

  def format_user
    self.name = name.downcase
    self.email = email.downcase
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def make_band
      self.band = true if BANDS.include? name
    end

end
