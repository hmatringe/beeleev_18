ActiveAdmin.register PartnerCategory do

  menu parent: 'CMS'

  config.filters    = false

  collection_action :sort, method: :post do
    params[:ids].each_with_index do |id, index|
      resource_class
        .where(id: id)
    end
    render nothing: true
  end

  index do

    column :name

    actions
  end

  show do
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end

    f.actions

  end

end
