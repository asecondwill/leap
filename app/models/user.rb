class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_person_name   
  
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :password_complexity  

  def password_complexity
    #https://github.com/heartcombo/devise/wiki/How-To:-Set-up-simple-password-complexity-requirements
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character (for example ! or -)'
  end
end
