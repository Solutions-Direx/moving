# encoding: utf-8
class Client < ActiveRecord::Base

  # SEARCH
  # ------------------------------------------------------------------------------------------------------
  include PgSearch
  multisearchable :against => [:name, :phone1, :phone2, :code, :email]
  pg_search_scope :search_by_keyword, 
                  :against => [:name, :phone1, :phone2, :code, :email],
                  :using => {
                    :tsearch => {
                      :prefix => true # match any characters
                    }
                  },
                  :ignoring => :accents
  

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :account
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address
  has_many :quotes, dependent: :destroy
  has_many :invoices
  

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :email, :name, :phone1, :phone2, :account_id, :address_attributes, :commercial, :billing_contact, :code, :department
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :phone1
  validates_uniqueness_of :code
  validates_uniqueness_of :name, scope: [:phone1, :department], message: "Combinaison du nom/téléphone/département doit être unique"


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :commercial, -> { where(commercial: true) }
  scope :residential, -> { where(commercial: false) }
  

  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_save :update_code


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def name_with_code
    department.present? ? "#{name_with_department} (#{code})" : "#{name} (#{code})"
  end

  def can_be_deleted?
    !quotes.any? and !invoices.any?
  end

  def name_with_department
    department.present? ? "#{name} - #{department}" : name
  end

  private
    
    def update_code
      if self.new_record?
        last_client_id = Client.last.present? ? Client.last.id : 0
        code_generation = "%05d" % (last_client_id + 1)
      else
        code_generation = "%05d" % (self.id)
      end
      self.code = commercial? ? "C#{code_generation}" : "R#{code_generation}"
    end
  
end
