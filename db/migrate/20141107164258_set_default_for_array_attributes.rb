class SetDefaultForArrayAttributes < ActiveRecord::Migration
  def change
    [
      :spoken_languages,
      :expertises,
      :international_activity_countries
    ].each do |attribute|
      change_column_default :users, attribute, []
    end
  end
end
