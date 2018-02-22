class ApplicationMailer < ActionMailer::Base

  include ActionView::Helpers::TextHelper

  default from: 'Beeleev <team@beeleev.com>'

  #
  # Delivers an email template to one or more receivers
  #
  # @param [EmailTemplate] email_template the template to be rendered
  # @param [Array, User] recipients a user or an array of users to be recipients
  # @param [Hash] options liquid options to render the email template
  def email_template(email_template, recipients, options = {})

    # make recipients an array if not already
    recipients = [recipients] unless recipients.is_a? Array

    # formats the recipients with their names
    # ie: ["Jean Dupont <jean.dupont@example.com>"]
    #
    #
    recipients_with_names = recipients.map do |recipient|
      # having a ',' in the name generates a
      # Net::SMTPServerBusy: 401 4.1.3 Bad recipient address syntax
      # error from mandrill
      name_without_comma = recipient.name.gsub(',', '')

      "#{name_without_comma} <#{recipient.email}>"
    end

    @subject = email_template.subject

    # build the mail headers
    headers = {
      to: recipients_with_names,
      subject: email_template.subject
    }

    # add the attachment
    if email_template.attachment.present?
      file = email_template.attachment.file
      attachments[file.filename] = file.read
    end

    # add the activity_url helper result to the liquid options
    if options['activity_url']
      options['activity_url'] = Rails.application.routes.url_helpers.activity_url
    end

    # render the email template with the liquid options
    # and simple_formats it
    mail headers do |format|
      rendered_template = email_template.render(options)
      format.html do
        render text: simple_format(rendered_template),
               layout: 'application_mailer'
      end
    end

    Rails.logger.info "#{email_template.name} sent to #{recipients_with_names}"
  end

  private

  # takes an array of objects responding to #name and #email and maps it to
  # ["obj1.name <obj1.email>", "obj2.name <obj2.email>"]
  def email_with_names(recipients)
    recipients.map do |recipient|
      "#{recipient.name} <#{recipient.email}>"
    end
  end
end
