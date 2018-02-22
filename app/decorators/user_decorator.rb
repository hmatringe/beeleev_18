class UserDecorator < Draper::Decorator
  delegate_all

  def active_network
    network.reject{ |u| !u.active? }
  end

  def network
  	connections_received + connections_sent
  end
  
  def connections_received
  	user2_connections.map(&:user1)
  end

  def connections_sent
  	user1_connections.map(&:user2)
  end

  def full_capitalized_name
  	first_name.upcase + " " + last_name.upcase
  end

  def full_titleized_name
    first_name.titleize + " " + last_name.titleize
  end

  def position_at_company
    position + " @" + company
  end

  def all_spoken_languages
    spoken_languages.map(&:capitalize).sort.join(", ")
  end
end
