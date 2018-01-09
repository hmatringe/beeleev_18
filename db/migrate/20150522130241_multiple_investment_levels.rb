class MultipleInvestmentLevels < ActiveRecord::Migration
  def change
    # create the new investment_levels array attribute
    add_column :users, :investment_levels, :string, array: true, default: []

    # Without this, the new investment_levels info will not be saved
    User.reset_column_information

    # loop on each user, fill the new plural investment_levels attribute with
    # the former singular investment_level value
    User.find_each do |user|
      # set the plural business sector attribute
      user.investment_levels = [user.investment_level]
      user.save
    end

    # remove the singular business_sector attribute
    remove_column :users, :investment_level
  end
end
