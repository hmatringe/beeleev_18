ActiveAdmin.register Partner do

  menu parent: 'CMS'

  config.filters    = false
  config.sort_order = 'position_asc'

  collection_action :sort, method: :post do
    params[:ids].each_with_index do |id, index|
      resource_class
        .where(id: id)
        .update_all(position: (index + 1))
    end
    render nothing: true
  end

  index do

    # if params[:order] == 'position_asc' && params[:q].nil?
    #   column do
    #     content_tag :span, class: 'handle' do
    #       '↕'
    #     end
    #   end
    # end
    
    column :position

    column :image do |resource|
      cl_image_tag resource.image.full_public_id,
                   width: 50,
                   height: 50,
                   crop: :lpad,
                   gravity: :center,
                   background: "#fff",
                   fetch_format: :auto
    end

    column :url do |resource|
      link_to resource.url, resource.url
    end

    column :title
    
    column :partner_category

    actions
  end

  controller do
    def create
      @partner = Partner.new(params[:partner])
      super do |format|
        redirect_to(admin_partner_path(@partner), notice: "Partner created") and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to(admin_partner_path(resource), notice: "Partner updated") and return if resource.valid?
      end
    end

    def destroy
      super do |format|
        redirect_to(admin_partners_path, notice: "Partner deleted") and return
      end
    end
  end

  show do
    attributes_table do
      row :image do
        cl_image_tag resource.image.full_public_id,
                     width: 150,
                     height: 150,
                     crop: :lpad,
                     gravity: :center,
                     background: "#fff",
                     fetch_format: :auto
      end

      row :url
      row :title
      row :body
    end
  end

  form do |f|
    f.inputs do
      f.input :image
      f.input :url
      f.input :title
      f.input :body
      f.input :position
      f.input :partner_category
    end

    f.actions

  end

end