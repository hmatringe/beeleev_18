class EmailTemplateSender

  attr_reader :template_name, :template

  def initialize(template_name, recipient_or_ivar_name)
    @template_name        = template_name
    @template             = EmailTemplate.find_by_name template_name
    @recipient_or_ivar_name  = recipient_or_ivar_name
  end

  def after(object)
    @object = object

    # send the email template if it exists
    ApplicationMailer.email_template(
      template, recipient, template_options
    ).deliver if (template && recipient)

  end

  private

  # Build the liquid options Hash from the object's instance variables
  def template_options

    if @object.respond_to? :email_template_options
      @object.email_template_options
    else
      Hash[
        @object.instance_variables.map do |name|
          [name.to_s.gsub('@', ''), @object.instance_variable_get(name)]
        end
      ]
    end

  end

  def recipient
    case @recipient_or_ivar_name
    when Symbol
      @object.instance_variable_get @recipient_or_ivar_name
    else
      @recipient_or_ivar_name
    end
  end

end
