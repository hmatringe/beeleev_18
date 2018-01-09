ActiveAdmin.register Comment do

  belongs_to :beeleever_post

  actions :index, :destroy

  config.sort_order = :created_at_desc

  # menu parent: 'Newsfeed'

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

    actions
  end

end
