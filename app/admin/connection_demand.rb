ActiveAdmin.register ConnectionDemand do

  menu parent: "Connections"

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


  config.resource_class.aasm.states.each do |state|
    scope state.name unless [
      :waiting_user1_response, :rejected_by_user1
    ].include? state.name
  end

  # Member action to send a valid aasm event to the resource
  member_action :send_aasm_event, method: :put do
    if resource.class.aasm.events.keys.include?(params[:aasm_event].to_sym)
      resource.send params[:aasm_event]
      resource.save
    end
    # redirect_to [:admin, resource], notice: "Event '#{params[:aasm_event]}' sent"
    redirect_to(
      admin_connection_demand_path(resource),
      notice: "Event '#{params[:aasm_event]}' sent"
      ) and return
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

  index do
    column :user1
    column :user2
    column :status
    column :created_at

    actions
  end

  controller do
    def create
      @connection_demand = ConnectionDemand.new(params[:connection_demand])
      super do |format|
        redirect_to(admin_connection_demand_path(@connection_demand), notice: "Connection Request created") and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to(admin_connection_demand_path(resource), notice: "Connection Request updated") and return if resource.valid?
      end
    end

    def destroy
      super do |format|
        redirect_to(admin_connection_demands_path, notice: "Connection Request deleted") and return
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

    panel 'User 2 reminders' do
      attributes_table_for resource do
        row :beeleev_accepted_at
        row :first_reminder_delay do
          "#{ConnectionDemand::FIRST_REMINDER_INTERVAL} days after " \
          "'#{ConnectionDemand.human_attribute_name(:beeleev_accepted_at)}'"
        end
        row :second_reminder_delay do
          "#{ConnectionDemand::SECOND_REMINDER_INTERVAL} days after " \
          "'#{ConnectionDemand.human_attribute_name(:beeleev_accepted_at)}'"
        end
        row :connection_demand_reminders_count
      end
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
    f.inputs "Details" do
      # f.input :user1_id#, as: :select2, select2_options: user_select2_options
      f.input :user1_id,
                as: :select,
                collection: User.all
      # f.input :user2_id#, as: :select2, select2_options: user_select2_options
      f.input :user2_id,
                as: :select,
                collection: User.all
      f.input :description
      f.input :reject_description
    end

    f.inputs "Feedback reminders" do
      f.input :send_feedback_reminders
      f.input :send_feedback_reminders_after
    end

    f.inputs "Administration" do
      f.input :status, as: :select, collection: f.object.class.aasm.states.map(&:name), include_blank: false
    end

    f.actions
  end

end
