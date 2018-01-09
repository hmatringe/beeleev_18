class ConnectionDrop < Liquid::Drop

  delegate :description, :reject_description, to: :object

  attr_reader :object

  def initialize(object)
    @object = object
  end

end
