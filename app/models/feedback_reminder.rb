class FeedbackReminder

  def initialize(connection, recipient, connected_user)
    @connection, @recipient, @connected_user =
      connection, recipient, connected_user
  end

  def send_feedback_reminder_email
    # render the template and deliver it
    ApplicationMailer.email_template(
      template, @recipient, template_options
    ).deliver
  end

  def feedback_url
    Rails.application.routes.url_helpers.activity_url(
      anchor: "feedback-for-connection-#{@connection.id}"
    )
  end

  # Private methods
  #################

  private

  def template
    EmailTemplate.find_by_name "feedback-reminder"
  end

  def template_options
    {
      'user1'        => @recipient,
      'user2'        => @connected_user,
      'feedback_url' => self.feedback_url
    }
  end

end
