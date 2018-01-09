class AddStatementDescriptorToProducts < ActiveRecord::Migration
  def change
    add_column :products, :statement_descriptor, :string
  end
end
