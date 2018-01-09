class MergeAfterUser2AcceptConnectionTemplates < ActiveRecord::Migration
  def change

    # Destroy obsolute after-user2-accept-connection-demand email template
    EmailTemplate.where(name: "after-user2-accept-connection-demand").destroy_all

    # Rename after-user2-accept-connection-proposition email template to
    # after-user2-accept-connection
    t = EmailTemplate.find_by_name("after-user2-accept-connection-proposition")
    t.update_attribute :name, "after-user2-accept-connection"
  end
end
