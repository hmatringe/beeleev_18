class BeeleeverSpaceController < ApplicationController

  before_action :authenticate_user!
  before_filter :pending_connections, except: [:create]

  protected

  def pending_connections
    @pending_connections = current_user
      .user2_connections
      .waiting_user2_response

    @pending_connections += current_user
      .user1_connections
      .waiting_user1_response
  end
end
