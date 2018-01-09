class AddAttachmentToEmailTemplates < ActiveRecord::Migration
  def change
    add_column :email_templates, :attachment, :string
  end
end
