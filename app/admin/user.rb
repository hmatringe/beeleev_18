ActiveAdmin.register User do

  config.sort_order = 'created_at_desc'


  menu label: 'Beeleevers'

  filter :first_name
  filter :last_name
  filter :email
  filter :profil, as: :select, collection: User.pluck(:profil).compact.uniq
  filter :country
  filter :company
  filter :international_activity_countries_overlap,
         as: :select,
         collection: CountrySelect.countries.values.sort

  scope :activation_pending
  scope :active
  scope :rejected
  scope :account_deleted

  actions :all, except: [:destroy]

  # Custom Controller Actions
  ###########################

  controller do
    def create
      # params[:user] does not contain a :password info
      # since the admin interface does not have that field
      @user = User.new(params[:user])

      # since the password attribute presence is required for the user to be
      # valid, let's give him a random one
      @user.password = Devise.friendly_token

      # proceed with the regular create method
      # see InheritedResources documentation
      create! do |format|
        redirect_to(admin_users_path, notice: "User #{@user.decorate.full_titleized_name} created") and return
      end
    end

    def update
      super do |format|
        redirect_to(admin_user_path(resource), notice: "User #{@user.decorate.full_titleized_name} updated") and return if resource.valid?
      end
    end

    def destroy
      super do |format|
        redirect_to(admin_users_path, notice: "User deleted") and return
      end
    end
  end

  # Member action to send a valid aasm event to the resource
  member_action :send_aasm_event, method: :put do
    if resource.class.aasm.events.keys.include?(params[:aasm_event].to_sym)

      # HACK
      resource.skip_turnover_validation = '1'
      resource.skip_staff_volume_validation = '1'

      resource.send params[:aasm_event]
      resource.save(validate: false)
    end

    # redirect_to(
    #   [:admin, resource],
    #   notice: "Event '#{params[:aasm_event]}' sent"
    # )
    if params[:aasm_event].to_sym == :destroy
      redirect_to(
        admin_users_path,
        notice: "Event '#{params[:aasm_event]}' sent"
        ) and return
    else
      redirect_to(
        admin_user_path(resource),
        notice: "Event '#{params[:aasm_event]}' sent"
        ) and return
    end
  end

  # Dynamically build action_items for each aasm event available
  # for the resource
  config.resource_class.aasm.events.each do |event_name, _event|
    # binding.pry
    if_proc = proc { resource.aasm.events.include? event_name }

    action_item only: :show, if: if_proc do
      
      link_to(
        event_name.to_s.titleize,
        polymorphic_path(
          [:admin, resource],
          action: 'send_aasm_event',
          aasm_event: event_name
        ),
        method: :put
      )
    end
  end

  # Index
  #######

  index title: 'Users' do
    
    column :first_name
    column :last_name
    column :email
    column :profil
    column :status
    column :country
    column :created_at

    actions
  end

  show do

    panel 'Public informations' do
      attributes_table_for resource do
        row :avatar do
          image_tag resource.avatar.url(:panel)
        end
        row :profil
        row :civility
        row :last_name
        row :first_name
        row :position
        row :country
        row :city
        row :nationalite
        row :twitter_account
        row :facebook_username
        row :business_sectors
        row :website do
          if resource.website_uri.present?
            link_to(
              resource.website,
              resource.website_uri.to_s,
              target: '_blank'
            )
          else
            resource.website
          end
        end
        row :description do
          simple_format resource.description
        end
        row :company
        row :company_description do
          simple_format resource.description
        end
      end
    end

    panel 'Private informations' do
      attributes_table_for resource do

        row :date_of_birth do
          l resource.date_of_birth, format: :long if resource.date_of_birth
        end
        row :email
        row :phone
        row :cellphone
        row :skype_account
        row :expertises
        row :spoken_languages
        row :entrepreneur_clubs
        row :investment_activity
        row :year_of_creation
        row :business_model
        row :international_activity
        row :international_activity_countries
        row :turnover
        row :staff_volume
        row :hiring_objectives
        row :investment_levels
      end
    end

    panel 'Provider' do
      attributes_table_for resource do
        row :provider
        row :uid
        row :provider_public_profile_url do
          link_to(
            resource.provider_public_profile_url,
            resource.provider_public_profile_url,
            target: '_blank') if resource.provider_public_profile_url.present?
        end
      end
    end

    panel 'Connection credits' do
      table_for resource.connection_credits.order(created_at: :desc) do
        column :expires_on do |resource|
          if resource.expires_on.present?
            l resource.expires_on, format: :long
          else
            'never'
          end
        end

        column :usable? do |resource|
          status_tag "#{resource.usable?}"
        end
        column :connection
        column :external? do |resource|
          status_tag "#{resource.external?}" if resource.external?
        end
        column :created_at
        column do |resource|
          link_to 'modifer', edit_admin_connection_credit_path(resource)
        end
      end
    end

    panel 'Newsfeed' do
      attributes_table_for resource do
        row :can_post
      end
    end

    panel 'Administration' do
      attributes_table_for resource do
        row :status
        row :created_at
        row :activated_at
        row :phone_interview_realized do
          resource.phone_interview_realized? ? 'yes' : 'no'
        end
        row :new_application_reminder_count
        row :activate_user_reminder_count
        row :application_reject_reason do
          simple_format resource.application_reject_reason
        end
        row :stripe_customer_id
      end
    end
  end

  form do |f|
    f.inputs 'Public informations' do
      f.input :avatar
      f.input :profil, as: :radio, collection: %w(Entrepreneur Expert Company)
      f.input :civility, as: :radio, collection: %w(Mr. Mrs. Ms. Dr.)
      f.input :last_name
      f.input :first_name
      f.input :position
      f.input :country, include_blank: true, priority_countries: []
      f.input :city
      f.input :nationalite
      f.input :twitter_account
      f.input :facebook_username
      f.input(
        :business_sectors,
        as: :select, collection: User::BUSINESS_SECTORS,
        multiple: true
      )
      f.input :website
      f.input :description
      f.input :company
      f.input :company_description
    end

    f.inputs 'Private informations' do
      f.input :date_of_birth, as: :string, hint: 'yyyy-mm-dd'
      f.input :email
      f.input :phone
      f.input :cellphone
      f.input :skype_account
      f.input(
        :expertises,
        as: :select,
        collection: User::EXPERTISES,
        multiple: true
      )
      f.input(
        :spoken_languages,
        as: :select,
        collection: User::LANGUAGES,
        multiple: true
      )
      f.input :entrepreneur_clubs
      f.input :investment_activity
      f.input :year_of_creation
      f.input :business_model, as: :select, collection: [
        'B2C',
        'B2B',
        'B2B2C',
        'B2B & B2C',
        'C2C',
        'B2G'
      ]
      f.input :international_activity
      f.input(
        :international_activity_countries,
        as: :select,
        collection: Country.all.map(&:first),
        multiple: true
      )
      f.input :skip_turnover_validation, as: :hidden, input_html: { value: '1' }
      f.input :turnover, as: :select, collection: [
        '0 to $100K',
        '$100K to $500K',
        '$500K to $1.000K',
        '$1.000K to $3.000K',
        '$3.000K to $5.000K',
        '$5.000K to $10.000K',
        'More than $10.000K',
        'More than $20.000K',
        'More than $50.000K',
        'More than $150.000K'
      ]

      f.input :skip_staff_volume_validation, as: :hidden, input_html: { value: '1' }
      f.input :staff_volume, as: :select, collection: [
        'myself only',
        '2-10',
        '11-50',
        '51-200',
        '201-500',
        '501-1000',
        '1001-5000',
        '5001-10000',
        '+10001'
      ]
      f.input :hiring_objectives
      f.input :investment_levels,
              as: :select,
              collection: [
                'Seed',
                'Serie A',
                'Serie B',
                'Serie C',
                'IPO',
                'None',
                'Other'
              ],
              multiple: true
    end

    f.inputs 'Newsfeed' do
      f.input :can_post#, as: :checkbox
    end

    f.inputs 'Administration' do
      f.input(
        :status,
        as: :select,
        collection: User.aasm.states.map(&:name),
        include_blank: true
      )
      f.input :phone_interview_realized
      f.input :new_application_reminder_count
      f.input :activate_user_reminder_count
      f.input :application_reject_reason

      if current_admin_user.super_admin?
        f.input :stripe_customer_id
      end
    end

    f.actions

  end

end
