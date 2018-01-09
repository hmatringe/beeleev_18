class BeeleeverPost < Post

  # Associations
  ##############

  has_many :comments, dependent: :destroy

end
