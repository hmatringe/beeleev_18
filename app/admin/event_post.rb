ActiveAdmin.register EventPost, as: 'News' do

  config.sort_order = :publication_date_desc

  menu parent: 'CMS', label: 'News'

  scope :published
  scope :non_published

  filter :title

  breadcrumb do
    crumbs = [
      link_to('admin', admin_root_path),
      'CMS'
    ]

    index_title = active_admin_config.get_page_presenter(:index).options[:title]

    if %w(new show edit).include?(action_name)
      crumbs << link_to(index_title, collection_path(resource))
    end

    if action_name == 'edit'
      crumbs << link_to(display_name(resource), resource_path(resource))
    end

    crumbs
  end

  csv do
    column :title
    column :subtitle
    column :body
    column :published
    column :publication_date
  end

  index title: 'News' do
    column :illustration do |resource|
      image_tag resource.illustration.thumbnail.url
    end
    column :title
    column :published
    column :publication_date

    actions
  end

  show do
    attributes_table do
      row :illustration do
        image_tag resource.illustration.url
      end
      row :title
      row :subtitle do
        resource.subtitle.html_safe
      end
      row :published
      row :publication_date
    end
  end

  form do |f|
    f.inputs do
      f.input(
        :illustration,
        hint: 'Will be resized to 555px wide while preserving aspect ratio'
      )
      f.input :title
      f.input :subtitle, input_html: { rows: 3 }, hint: 'HTML'
      f.input :body, hint: 'HTML'
      f.input :detailed_body, hint: 'HTML'
      f.input :published
      f.input :publication_date
    end

    f.actions
  end

end
