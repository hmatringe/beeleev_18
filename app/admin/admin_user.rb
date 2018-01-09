ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  menu priority: 100

  filter :email

  index do
    selectable_column
    id_column
    column :email
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
