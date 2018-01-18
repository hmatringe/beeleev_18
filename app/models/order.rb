# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  product_id       :integer
#  cents            :integer
#  currency         :string(255)
#  stripe_charge_id :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Order < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :user
  belongs_to :product

  # Callbacks
  ###########

  before_save :set_cents
  before_save :create_stripe_charge
  after_save -> { product.purchased(user) }

  # Validations
  #############

  validate :check_currency

  # Instance methods
  ##################

  delegate :title, :statement_descriptor, :money, to: :product, prefix: true

  # @return [Money]
  # The Money object combining cents and currency
  def money
    set_cents
    Money.new(cents, currency)
  end

  private

  def set_cents
    MoneyService.update_rates
    self.cents = product_money.exchange_to(currency).cents
  end

  def create_stripe_charge
    charge = Stripe::Charge.create(
      customer: user.stripe_customer_id,
      amount: cents,
      description: product_title,
      currency: currency,
      statement_descriptor: product_statement_descriptor
    )

    self.stripe_charge_id = charge.id
  end

  def check_currency
    Money::Currency.new currency
  rescue Money::Currency::UnknownCurrency
    errors.add(:currency, 'unknown')
  end

end
