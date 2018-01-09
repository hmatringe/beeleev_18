ActiveAdmin.register ConnectionRequest do

  menu parent: 'Connections'

  controller do
    def scoped_collection
      end_of_association_chain.includes(:author)
    end
  end

  user_select2_options = {
    placeholder: 'Select the author',
    resourcesPath: '/admin/users',
    queryKey: 'q[first_name_or_last_name_cont]',
    order: 'last_name_asc',
    resultFormat: "data.first_name + ' ' + data.last_name"
  }

  select2_filter :author_id, input_html: {data: {
    select2_options: user_select2_options
  }}

  filter :subject

  config.resource_class.aasm.states.each do |state|
    scope state.name
  end

  index do
    column :author
    column :subject
    column :status
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :author
      row :subject
      row :countries
      row :business_sectors do
        resource.business_sectors.join(', ')
      end
      row :description do
        simple_format resource.description
      end
    end
  end

  form do |f|
    f.inputs 'Details' do
      f.input :author_id, as: :select2, select2_options: user_select2_options
      f.input :subject
      f.input :status,
              as: :select,
              collection: f.object.aasm.states,
              include_blank: false
      f.input :countries, as: :string
      f.input :business_sectors,
              as: :select,
              collection: User::BUSINESS_SECTORS,
              include_blank: false,
              input_html: {multiple: true}
      f.input :description
    end

    f.actions
  end

end
