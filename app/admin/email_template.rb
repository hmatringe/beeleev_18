ActiveAdmin.register EmailTemplate do

  menu parent: 'CMS'

  config.filters = false
  config.sort_order = 'name_asc'

  actions :all, except: [:new, :create, :destroy]

  index do
    column :id
    column :name
    column :subject

    actions
  end

  controller do
    def update
      super do |format|
        redirect_to(admin_email_template_path(resource), notice: "Email updated goffio") and return if resource.valid?
      end
    end
  end

  show do
    attributes_table do
      row :name
      row :subject
      row :body do
        simple_format resource.body
      end
      row :attachment do
        link_to resource.attachment.url, resource.attachment.url \
        if resource.attachment?
      end
    end
  end

  form do |f|
    body_hints = [
      '{{activity_url}}',
      '{{user1.first_name}}',
      '{{user1.last_name}}',
      '{{user1.name}} (ie: "first_name last_name")',
      '{{user1.profile_url}}'
    ]

    body_hints +=
    case f.object.name
    when 'feedback-reminder'
      ['{{feedback_url}}']
    when /connection/
      [
        '{{user2.first_name}}',
        '{{user2.last_name}}',
        '{{user2.name}} (ie: "first_name last_name")',
        '{{user2.profile_url}}',
        '{{connection.description}}',
        '{{connection.reject_description}}'
      ]
    when 'after-reject-user'
      ['{{user1.application_reject_reason}}']
    else
      []
    end

    if [
      'after-new-connection-proposition',
      'after-user1-accept-connection-proposition',
      'after-beeleev-accept-connection-demand-to-user-2'
    ].include?(f.object.name)
      body_hints += ['{{answer_url}}']
    end

    body_hint =
      'You can use the following variables in the template <br><br>' +
      body_hints.sort.join('<br>')

    f.inputs 'Details' do
      f.input :subject
      f.input :body, hint: body_hint.html_safe
      f.input :attachment
      f.input :remove_attachment, as: :boolean
    end

    f.actions
  end

end
