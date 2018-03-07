ActiveAdmin.register ConnectionProposition do

  menu parent: "Connections"

  # Custom Controller Actions
  ###########################


  controller do

    # Inherited resources methods overrides
    #######################################

    def scoped_collection
      end_of_association_chain.includes(:user1, :user2)
    end

    # Callbacks
    ###########

    after_action(
      EmailTemplateSender.new("after-new-connection-proposition", :@recipient),
      only: [:create]
    )

    # Actions
    #########

    # Set the recipient for the email template sender used in the after_action
    # filter
    def create
      super
      @recipient = resource.user1
    end

    # Instance methods
    ##################

    def email_template_options
      resource.email_template_options
    end

  end

  # Member action to send a valid aasm event to the resource
  member_action :send_aasm_event, method: :put do
    if resource.class.aasm.events.keys.include?(params[:aasm_event].to_sym)
      resource.send params[:aasm_event]
      resource.save
    end

    redirect_to [:admin, resource], notice: "Event '#{params[:aasm_event]}' sent"
  end

  # Dynamically build action_items for each aasm event available
  # for the resource
  config.resource_class.aasm.events.each do |event_name, event|

    if_proc = proc{ resource.aasm.events.include? event_name }

    action_item only: :show, :if => if_proc do
      link_to(
        event_name.to_s.titleize,
        polymorphic_path([:admin, resource], action: 'send_aasm_event', aasm_event: event_name),
        method: :put
      )
    end
  end

  # Filters
  #########

  user_select2_options = {
    placeholder: "Select a user",
    resourcesPath: "/admin/users",
    queryKey: "q[first_name_or_last_name_cont]",
    order: "last_name_asc",
    resultFormat: "data.first_name + ' ' + data.last_name"
  }

  # select2_filter :user1_id, input_html: {data: {
  #   select2_options: user_select2_options
  # }}

  # select2_filter :user2_id, input_html: {data: {
  #   select2_options: user_select2_options
  # }}

  filter :status, as: :select, collection: ConnectionProposition.aasm.states.map(&:name).sort

  config.resource_class.aasm.states.each do |state|
    scope state.name unless [
      :waiting_beeleev_response, :rejected_by_beeleev
    ].include? state.name
  end

  index do
    column :user1
    column :user2
    column :status
    column :created_at

    actions
  end

  controller do
    def create
      @connection_proposition = ConnectionProposition.new(params[:connection_proposition])
      super do |format|
        redirect_to(admin_connection_proposition_path(@connection_proposition), notice: "Connection Proposition created") and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to(admin_connection_proposition_path(resource), notice: "Connection Proposition updated") and return if resource.valid?
      end
    end

    def destroy
      super do |format|
        redirect_to(admin_connection_propositions_path, notice: "Connection Proposition deleted") and return
      end
    end
  end

  show do
    attributes_table do
      row :user1
      row :user2
      row :status
      row :description do
        simple_format resource.description
      end
      row :reject_description do
        simple_format resource.reject_description
      end
      row :created_at
      row :updated_at
    end

    panel "Feedback reminders" do
      attributes_table_for resource do
        row :send_feedback_reminders
        row :send_feedback_reminders_after
        row :feedback_reminders_count
      end
    end

    panel "Feedbacks" do
      table_for resource.feedbacks do
        column :author
        column :contacted
        column :quality_of_qualification
        column :quality_of_contact
        column :prolific_contact
        column :met
        column :would_you_recommend do |feedback|
          feedback.would_you_recommend? ? "Yes" : "No"
        end
        column :description do |feedback|
          simple_format feedback.description
        end
      end
    end
  end

  form do |f|

    # if Rails.env.development?
    #   f.inputs 'Debug' do
    #     debug params
    #   end
    # end

    if f.object.new_record?
      f.inputs "Connection Credits" do
        f.input :consume_credit, as: :boolean, hint: 'Consume a connection credit of User 1 and link this connection proposition with it'
      end
    end

    f.inputs "Details" do
      f.input :user1_id#, as: :select2, select2_options: user_select2_options
      f.input :user2_id#, as: :select2, select2_options: user_select2_options
      f.input :description
      f.input :reject_description
    end

    f.inputs "Feedback reminders" do
      f.input :send_feedback_reminders
      f.input :send_feedback_reminders_after
    end

    f.inputs "Administration" do
      f.input :status, as: :select, collection: f.object.class.aasm.states.map(&:name), include_blank: false unless f.object.new_record?
    end

    f.actions
  end

end
