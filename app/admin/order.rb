ActiveAdmin.register Order do

  menu parent: 'Shop', position: 2

  actions :index, :show

  user_select2_options = {
    placeholder: 'Select a user',
    resourcesPath: '/admin/users',
    queryKey: 'q[first_name_or_last_name_cont]',
    order: 'last_name_asc',
    resultFormat: 'data.first_name + \' \' + data.last_name'
  }

  # select2_filter :user_id, input_html: {data: {
  #   select2_options: user_select2_options
  # }}

  filter :product

  index do
    column :id
    column :user
    column :product
    column 'Price' do |resource|
      number_to_currency(
        resource.money.amount,
        unit: resource.money.currency.code
      )
    end

    column :stripe_charge_id
    column :created_at
  end

end
