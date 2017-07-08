class Product < ApplicationRecord

# we can define validations here, validations will be called before saving
# or before creating a record and will prevent the saving or creation from
# happening if the validation rules are not met.
# we can call `.save` we will get back `true` if it completes successfully and
# will get back `false` if validations fail

# The title must be present
# The title must be unique (case insensitive)
# The price must be a number that is more than 0
# The description must be present
# The description must have at least 10 characters


  validates(:title, { presence: { message: 'must be provided' },
                      uniqueness: { case_sensitive: false },
                      exclusion: {in: %w(Apple Microsoft Sony), message: "%{value} is reserved."}
                    })

  validates(:price, numericality: { greater_than: 0 })
  # validates :price, {presence: true, numericality: {greater_than: 0}}

  validates(:description, { presence: { message: 'must be provided' },
                      length: { minimum: 10  }
                    })
  # validates :description, {presence: true, length: {minimum: 10}}

  validate :price_is_valid_decimal_precision

  validates :sale_price, numericality: {less_than_or_equal_to: :price,
    message: 'Sale price must be less than the price'}

  # Add the following callbacks methods to your product model:
  # A callback method to set the default price to 1
  # A callback method to capitalize the product title before saving

  after_initialize :set_defaults
  before_validation :set_sale_price
  before_validation :capitalize_title
  before_destroy :destroy_notification

  # scope :search, lambda {|count| order({ created_at: :desc }).limit(count) }
  def self.search(str)
    search_term = str
    where(["title LIKE? OR description LIKE?", "%#{search_term}%", "%#{search_term}%"]).order(:title, :description)
  end

  # # scope :recent, lambda {|count| order({ created_at: :desc }).limit(count) }
  # def self.search(str)
  #   search_term = str
  #   where(["title LIKE? OR description LIKE?", "%#{search_term}%", "%#{search_term}%"])
  # end

  private

  def price_is_valid_decimal_precision
    if price.to_f != price.to_f.round(7)
      errors.add(:price, "The price of the product is invalid. There should only be two digits at most after the decimal point.")
    end
  end

  def set_defaults
    self.price ||= 1
  end

  def set_sale_price
    self.sale_price  ||= self.price
    self.sale_price = self.price if self.sale_price > self.price
  end

  def capitalize_title
    self.title = title.capitalize if title.present?
  end

  def destroy_notification
    Rails.logger.warn("The Product #{self.title} is about to be deleted")
  end

end
