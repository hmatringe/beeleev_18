class ActivitiesController < BeeleeverSpaceController

  # 
  # def show
  #   authorize! :access_activity, current_user

  #   @connections_history =
  #     current_user.user1_connections.history +
  #     current_user.user2_connections.history

  #   # Order connections_history by created_at desc
  #   @connections_history = @connections_history.sort_by(&:created_at).reverse

  #   @connection_requests = current_user.connection_requests.order("created_at desc")

  #   @connection_credits = current_user.connection_credits.order(created_at: :desc)

  # rescue CanCan::AccessDenied
  #   redirect_to edit_account_path
  # end

end
