class OrdersController < BeeleeverSpaceController

  # Filters
  #########

  before_filter :create_stripe_customer, only: [:create]

  # Actions
  #########

  def create
    @order = current_user.orders.new params.require(:order).permit(
      :product_id, :currency
    )

    if @order.save
      redirect_to new_connection_request_path
    else
      flash[:notice] = @order.errors.full_messages.join('<br>'.html_safe)
      redirect_to direct_request_path
    end

  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to direct_request_path
  rescue => e
    raise if Rails.env.development?
    Rails.logger.error "orders#create failed with : '#{e.message}'".red

    flash[:notice] = 'We are sorry but we could not process your order'
    redirect_to direct_request_path
  end

  # Private
  #########

  private

  def create_stripe_customer
    return true if current_user.stripe_customer_id?

    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken],
      description:
        "Beeleever - id: #{current_user.id}, name: #{current_user.name}"
    )

    Rails.logger.info("New stripe customer created with id '#{customer.id}'")
    current_user.update_attribute :stripe_customer_id, customer.id
  end

end
