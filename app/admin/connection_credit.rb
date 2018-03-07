ActiveAdmin.register ConnectionCredit do

  config.sort_order = 'created_at_desc'

  menu parent: 'Connections'

  user_select2_options = {
    placeholder: 'Select a user',
    resourcesPath: '/admin/users',
    queryKey: 'q[first_name_or_last_name_cont]',
    order: 'last_name_asc',
    resultFormat: "data.first_name + ' ' + data.last_name"
  }

  # select2_filter :user_id, input_html: { data: {
  #   select2_options: user_select2_options
  # } }

  index do
    column :user
    column :expires_on do |resource|
      if resource.expires_on.present?
        l resource.expires_on, format: :long
      else
        'never'
      end
    end
    column :usable? do |resource|
      status_tag "#{resource.usable?}"
    end
    column :connection
    column :external? do |resource|
      status_tag "#{resource.external?}" if resource.external?
    end
    column :created_at

    actions
  end

  controller do
    def create
      @connection_credit = ConnectionCredit.new(params[:connection_credit])
      super do |format|
        redirect_to(admin_connection_credit_path(@connection_credit), notice: "Connection Credit created") and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to(admin_connection_credit_path(resource), notice: "Connection Credit updated") and return if resource.valid?
      end
    end

    def destroy
      super do |format|
        redirect_to(admin_connection_credits_path, notice: "Connection Credit deleted") and return
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :user_id#, as: :select2, select2_options: user_select2_options
      f.input :expires_on, as: 'datepicker'
    end

    f.inputs 'Connection with a Beeleever' do
      f.input :connection_id, label: 'connection_id'
    end

    f.inputs 'Connection outside Beeleev network' do
      f.input :external, \
              label: 'Use this credit with someone outside of Beeleev network ?'
      f.input :external_connection_date, as: :datepicker
      f.input :external_comments
    end

    f.actions
  end

end
