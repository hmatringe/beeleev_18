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

    column :position

    column :name

    actions
  end

  controller do
    
    def create
      @partner_category = PartnerCategory.new(params[:partner_category])
      super do |format|
        redirect_to(admin_partner_categories_path, notice: "Partner Category created") and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to(admin_partner_category_path(resource), notice: "Partner Category updated") and return if resource.valid?
      end
    end

    def destroy
      if resource.partners.present?
        redirect_to(admin_partner_categories_path, notice: "Remove all partners from a category before deleting it") and return
      end
      super do |format|
        redirect_to(admin_partner_categories_path, notice: "Partner Category deleted") and return
      end
    end
  end

  show do
    attributes_table do
      row :name
      row :position
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :position
    end

    f.actions

  end

end
