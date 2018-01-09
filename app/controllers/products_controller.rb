class ProductsController < ApplicationController
  def show
    @code_is_valid = false
    @coupon = Coupon.where(code: params[:coupon_code]).first
    @product = Product.find params[:id]

    return unless @coupon && @coupon.valid_for_user?(current_user)

    @code_is_valid = true
    @old_amount = Money.new(@product.amount, @product.currency)
    @product.amount = @product.amount *
                      (1 - @coupon.discount_percentage / 100.0)
  end

end
