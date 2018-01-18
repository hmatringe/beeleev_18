# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  amount               :integer
#  currency             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  statement_descriptor :string(255)
#

require 'spec_helper'

describe Product do
  pending "add some examples to (or delete) #{__FILE__}"
end
