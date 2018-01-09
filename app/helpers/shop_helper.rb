module ShopHelper

  def stripe_checkout_button(description, money, email)
    price = number_to_currency(money.amount, unit: money.currency.code)

    javascript_include_tag(
      'https://checkout.stripe.com/checkout.js',
      class: 'stripe-button',
      data: {
        key: StripeService.publishable_key, name: 'Beeleev',
        description: description, amount: money.cents,
        currency: money.currency.iso_code,
        email: email, image: image_path('foo.png'), allow_remember_me: false,
        label: "Buy in #{money.currency.code}"
      }
    )
  end

end
