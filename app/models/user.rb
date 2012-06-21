class User < ActiveRecord::Base
  # CONSTANTS
  module Role
    MANAGER     = 'manager'
    STANDARD    = 'standard'
    REMOVAL_MAN = 'removal_man'
    
    def self.options
      [[I18n.t(MANAGER), MANAGER], [I18n.t(STANDARD), STANDARD], [I18n.t(REMOVAL_MAN), REMOVAL_MAN]]
    end
  end
  
  # DEVISE
  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  # ASSOCIATIONS
  belongs_to :account
  has_many :quote_confirmations
  has_many :quotes
  
  # ATTRIBUTES
  attr_accessible :login, :username, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :role, :localization
  
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  
  # VALIDATIONS
  validates :account_id, :role, :username, :first_name, :last_name, :presence => true
  validates :username, :uniqueness => true
  
  # SCOPES
  scope :account_owner, where(account_owner: true)
  scope :managers, where(role: Role::MANAGER)
  scope :standards, where(role: Role::STANDARD)
  scope :removal_men, where(role: Role::REMOVAL_MAN)
  default_scope :order => "first_name, last_name"
  
  # INSTANCE METHODS
  
  [Role::MANAGER, Role::STANDARD, Role::REMOVAL_MAN].each do |method|
   define_method "#{method}?" do
      self.role == method
   end
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(active: true).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end
  
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 

    update_attributes(params) 
  end
end
