class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title

  default_scope :order => 'title'

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  #Validation stuff
  validates :title, :description, :image_url, :presence =>true #to validate if there's content
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01} #to validate if the price has a valid number
  validates :title, :uniqueness => true #to validate if the title is unique
  validates :title, :length => { minimum:10 }
  validates :image_url, :format => {
      :with =>%r{\.(gir|jpg|png)$}i,
      :message => 'must be a URL for GIF,JPG or PNG image.'
  }


  private

  #ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end


end
