# == Schema Information
#
# Table name: email_templates
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  subject    :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  attachment :string(255)
#

class EmailTemplate < ActiveRecord::Base

  validates_presence_of :name, :subject
  validate :valid_template

  mount_uploader :attachment, AttachmentUploader

  # Instance methods
  ##################

  # Used by AA
  def display_name
   subject
  end

  # @return [Liquid::Template]
  def template
    Liquid::Template.parse body
  end

  def render(options = {})
    template.render options
  end

  #
  # Usable string representation
  #
  def to_s
   "[EmailTemplate] From: '#{subject}': #{body}"
  end

  private

  def valid_template
    Liquid::Template.parse(body)
  rescue Liquid::SyntaxError => error
    errors.add:body,  "Invalid template: #{error}"
  end

end
