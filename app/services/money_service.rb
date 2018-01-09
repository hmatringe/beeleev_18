class MoneyService

  class << self
    def bank_cache
      (Rails.root + 'vendor/money/exchange_rates.xml').to_s
    end

    def save_rates
      Money.default_bank.save_rates(bank_cache)
    end

    def update_rates(force = false)
      return unless force || should_update_rates?
      Money.default_bank.update_rates(bank_cache)
    end

    def should_update_rates?
      return true if !Money.default_bank.rates_updated_at
      Money.default_bank.rates_updated_at < Time.now - 1.day
    end

    def available_currencies_code_and_iso
      Money::Currency.all.map do |currency|
        [currency.code, currency.iso_code]
      end

    end
  end

end
