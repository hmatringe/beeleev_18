
beeleev_currencies = [:usd, :eur]

# unregister all currencies except the ones in beeleev_currencies
Money::Currency.all.each do |currency|
  next if beeleev_currencies.include? currency.id
  Money::Currency.unregister currency.id
end

# use ECB for exchange rates
Money.default_bank = EuCentralBank.new

# download the rates xml file and load it
MoneyService.save_rates
MoneyService.update_rates
