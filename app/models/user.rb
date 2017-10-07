class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :department
  has_many :scores

    validates :year_of_adm, numericality: { greater_than_or_equal_to: 2011 }
   scope :user,  ->()    { where("#{self.to_s.downcase.pluralize}.role = 15")}    
    def admin?
    	(self.role == 20)
    end
	
    def user?
    	(self.role == 10)
    end
    
    def teacher?
    	(self.role == 15)
    end


    def role_name
      role = {10 => "user", 15 => "teacher", 20 => "admin"}
      role[self.role] || "user"
    end
end