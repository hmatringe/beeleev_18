class ShopController < BeeleeverSpaceController

  # Actions
  #########

  def show
    @products = Product.order(amount: :asc).all
  end

end
