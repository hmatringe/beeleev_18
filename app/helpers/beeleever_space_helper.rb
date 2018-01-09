module BeeleeverSpaceHelper

  def activities_badge_content(pending_connections)
    pending_connections.empty? ? nil : pending_connections.size
  end

end
