class StripeService

  class << self

    def live?
      ENV['STRIPE_LIVE'].to_i == 1
    end

    def publishable_key
      if live?
        ENV['STRIPE_LIVE_PUBLISHABLE_KEY']
      else
        ENV['STRIPE_TEST_PUBLISHABLE_KEY']
      end
    end

    def secret_key
      if live?
        ENV['STRIPE_LIVE_SECRET_KEY']
      else
        ENV['STRIPE_TEST_SECRET_KEY']
      end
    end
  end

end
