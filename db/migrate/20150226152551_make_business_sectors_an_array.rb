class MakeBusinessSectorsAnArray < ActiveRecord::Migration
  def change
    # create the new business_sectors array attribute
    add_column :users, :business_sectors, :string, array: true, default: []

    # Without this, the new business_sectors info will not be saved
    User.reset_column_information

    # loop on each user, fill the new plural business_sectors attribute with
    # the former singular business_sector value
    User.find_each do |user|
      # set the plural business sector attribute
      user.business_sectors = [user.business_sector]
      user.save
    end

    # remove the singular business_sector attribute
    remove_column :users, :business_sector
  end
end
