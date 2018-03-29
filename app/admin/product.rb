ActiveAdmin.register Product do

  menu parent: 'Shop', position: 1

  config.filters = false
  config.sort_order = 'amount_asc'

  actions :index, :update, :edit, :destroy

  # make sure the exchange rates are up-to-date
  MoneyService.update_rates

  index do
    column :title

    # 1 column for each available_currency displaying the exchanged price
    Money::Currency.all.each do |currency|
      column "Price in #{currency.code}" do |resource|
        number_to_currency(
          resource.money.exchange_to(currency.iso_code).amount,
          unit: currency.code
        )
      end
    end

    actions
  end

  controller do
    def update
      super do |format|
        redirect_to(admin_products_path, notice: "Product updated") and return if resource.valid?
      end
    end

    def destroy
      super do |format|
        redirect_to(admin_products_path, notice: "Product deleted") and return
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title if current_admin_user.super_admin?
      f.input :description
      f.input :amount, hint: 'in cents'
      f.input(
        :currency,
        as: :select,
        collection: MoneyService.available_currencies_code_and_iso
      )
      f.input :statement_descriptor, hint: "Will appear on the beeleever's credit card statement. Must not be more than #{Product::STATEMENT_DESCRIPTOR_MAX_LENGTH} characters long"
    end

    f.actions
  end

end
