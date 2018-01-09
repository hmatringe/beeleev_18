class OldConnectionDemand < ActiveRecord::Base
  self.table_name = "connection_demands"

  def new_status
    case status
    when "sent"
      "waiting_user2_response"
    when "accepted"
      "live"
    when "rejected"
      "rejected_by_user2"
    end
  end
end

class OldConnectionProposition < ActiveRecord::Base
  self.table_name = "connection_propositions"

  def new_status
    case status
    when "sent_to_user"
      "waiting_user1_response"
    when "forwarded_to_proposed_user"
      "waiting_user2_response"
    when "accepted"
      "live"
    when "rejected_by_user"
      "rejected_by_user1"
    when "rejected_by_proposed_user"
      "rejected_by_user2"
    end
  end
end

class RefactorConnections < ActiveRecord::Migration

  def up
    add_column :connections, :type, :string
    add_column :connections, :status, :string
    add_column :connections, :description, :text

    remove_index :connections, [:user2_id, :user1_id]
    remove_index :connections, [:user1_id, :user2_id]

    add_index :connections, [:user1_id, :user2_id]

    ConnectionDemand.reset_column_information
    ConnectionProposition.reset_column_information

    OldConnectionDemand.all.each do |e|
      ConnectionDemand.create(
        user1_id: e.requester_id,
        user2_id: e.target_id,
        description: e.description,
        status: e.new_status,
        created_at: e.created_at
      )
    end

    OldConnectionProposition.all.each do |e|
      ConnectionProposition.create!(
        user1_id: e.for_user_id,
        user2_id: e.proposed_user_id,
        description: e.description,
        status: e.new_status,
        created_at: e.created_at
      )
    end
  end

  def down
    remove_column :connections, :type, :string
    remove_column :connections, :status, :string
    remove_column :connections, :description, :text
  end

end
