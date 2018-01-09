class User
  module Ransackers

    extend ActiveSupport::Concern

    included do

      ransacker :full_name do |parent|
        Arel::Nodes::NamedFunction.new("concat_ws", [
          ' ', parent.table[:first_name], parent.table[:last_name]
        ])
      end

      ransacker :unaccented_full_name do |parent|
        Arel::Nodes::NamedFunction.new("concat_ws", [
          ' ',
          Arel::Nodes::NamedFunction.new("unaccent", [parent.table[:first_name]]),
          Arel::Nodes::NamedFunction.new("unaccent", [parent.table[:last_name]])
        ])
      end

    end

  end
end
