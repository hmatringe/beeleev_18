ActiveAdmin.register Feedback do

  menu parent: "Connections"

  actions :index, :show
  filter :author

  index do
    column :author
    column :connection
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :author
      row :connection
      row :contacted
      row :quality_of_qualification
      row :quality_of_contact
      row :prolific_contact
      row :met
      row :would_you_recommend do
        resource.would_you_recommend? ? "Yes" : "No"
      end
      row :description do |resource|
        simple_format resource.description
      end
    end
  end

end
