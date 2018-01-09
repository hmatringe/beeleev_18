ActiveAdmin.register BeeleeverPost do

  actions :index, :show, :destroy

  config.sort_order = :created_at_desc

  menu parent: 'Newsfeed'

  # Filters
  #########

  user_select_options = {
    placeholder: "Select a user",
    resourcesPath: "/admin/users",
    queryKey: "q[first_name_or_last_name_cont]",
    order: "last_name_asc",
    resultFormat: "data.first_name + ' ' + data.last_name"
  }

  # select2_filter :author_id, input_html: {data: {
  #   select2_options: user_select_options
  # }}

  index do
    column :author
    column :body
    column :illustration do |resource|
      image_tag resource.illustration.thumbnail.url
    end

    actions do |resource|
      link_to("Comments", admin_beeleever_post_comments_path(resource), class: "member_link")
    end
  end

  show do
    attributes_table do
      row :author
      row :body do
        simple_format resource.body
      end
      row :illustration do
        image_tag resource.illustration.url
      end
    end
  end

end
