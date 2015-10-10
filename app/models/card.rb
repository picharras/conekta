class Card < ActiveRecord::Base

  validates :number,
    presence: true,
    format: { with: /\A(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})\z/,
    message: "%{value} is not a valid credit card"}
  validates :expiration,
    presence: true,
    format: { with: /\A\d{2}-\d{2}\z/, message: "%{value} is invalid. Please enter a valid cvv" }
  validates :token, presence: true
  validates :amount, presence: true
end
