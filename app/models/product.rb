# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  amount               :integer
#  currency             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  statement_descriptor :string(255)
#

class Product < ActiveRecord::Base

  # Constants
  ###########

  STATEMENT_DESCRIPTOR_MAX_LENGTH = 22

  # Validations
  #############

  validates :amount, presence: true, numericality: { only_integer: true }
  validates :currency, presence: true
  validates :statement_descriptor, length: {
    maximum: STATEMENT_DESCRIPTOR_MAX_LENGTH
  }

  # Instance methods
  ##################

  # @return [Money]
  # The Money object combining amount and currency
  def money
    Money.new(amount, currency)
  end

  # @return [Money]
  # The Money object exchanged_to the 'eur' currency
  def euro_money
    MoneyService.update_rates
    money.exchange_to('eur')
  end

  def purchased(user)
    in_one_year = Time.zone.today + 1.year

    case title
    when 'Single connection'
      user.connection_credits.create
    when '5 connections pack'
      5.times { user.connection_credits.create(expires_on: in_one_year) }
    when '10 connections pack'
      10.times { user.connection_credits.create(expires_on: in_one_year) }
    end
  end

end
