ActiveAdmin.register Coupon do

  menu parent: 'Shop', position: 3
  actions :all, except: [:new, :create, :show]

  config.filters = false

  index do
    column :code
    column :discount_percentage do |resource|
      number_to_percentage resource.discount_percentage, precision: 0
    end
    column :validity_duration do |resource|
      "#{resource.validity_duration} month"
    end

    actions
  end
  controller do
    def update
      super do |format|
        redirect_to(admin_coupons_path, notice: "Coupon updated") and return if resource.valid?
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :code
      f.input :discount_percentage, as: :select, collection: (1..100).map { |i|
        [number_to_percentage(i, precision: 0), i]
      }

      f.input :validity_duration, as: :select, collection: (1..24).map { |i|
        ["#{i} month", i]
      }
    end

    f.actions
  end

end
