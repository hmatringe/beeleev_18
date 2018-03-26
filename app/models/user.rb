# == Schema Information
#
# Table name: users
#
#  id                               :integer          not null, primary key
#  first_name                       :string(255)
#  last_name                        :string(255)
#  email                            :string(255)
#  created_at                       :datetime
#  updated_at                       :datetime
#  provider                         :string(255)
#  uid                              :string(255)
#  avatar                           :string(255)
#  created_date                     :date
#  week                             :integer
#  active                           :string(255)
#  sponsor                          :string(255)
#  source                           :string(255)
#  profil                           :string(255)
#  prospects                        :string(255)
#  civility                         :string(255)
#  nationalite                      :string(255)
#  city                             :string(255)
#  country                          :string(255)
#  cellphone                        :string(255)
#  position                         :string(255)
#  company                          :string(255)
#  activities_1                     :text
#  activities_2                     :text
#  turnover                         :string(255)
#  staff_volume                     :string(255)
#  website                          :string(255)
#  url_profile                      :string(255)
#  meeting_form                     :string(255)
#  status                           :string(255)
#  provider_public_profile_url      :string(255)
#  encrypted_password               :string(255)      default(""), not null
#  reset_password_token             :string(255)
#  reset_password_sent_at           :datetime
#  remember_created_at              :datetime
#  phone                            :string(255)
#  twitter_account                  :string(255)
#  skype_account                    :string(255)
#  spoken_languages                 :string(255)      default([]), is an Array
#  expertises                       :string(255)      default([]), is an Array
#  date_of_birth                    :date
#  entrepreneur_clubs               :string(255)
#  investment_activity              :boolean
#  year_of_creation                 :string(255)
#  description                      :text
#  tagline                          :string(255)
#  business_model                   :string(255)
#  international_activity           :boolean
#  international_activity_countries :text             default([]), is an Array
#  growth_rate                      :string(255)
#  current_customers                :text
#  current_partners                 :text
#  hiring_objectives                :boolean
#  phone_interview_realized         :boolean          default(FALSE)
#  new_application_reminder_count   :integer          default(0)
#  application_reject_reason        :text
#  business_sectors                 :string(255)      default([]), is an Array
#  investment_levels                :string(255)      default([]), is an Array
#  activate_user_reminder_count     :integer          default(0)
#  activated_at                     :datetime
#  stripe_customer_id               :string(255)
#  can_post                         :boolean          default(TRUE)
#  company_description              :string(255)      default("")
#  facebook_username                :string(255)      default("")
#

class User < ActiveRecord::Base

  include Ransackers

  # Constants
  ###########

  EXPERTISES = YAML.load (Rails.root + 'config/expertises.yml').read
  BUSINESS_SECTORS = YAML.load (Rails.root + 'config/business_sectors.yml').read

  LANGUAGES = [
    'Afrikaans',
    'Albanian',
    'Arabic',
    'Armenian',
    'Basque',
    'Bengali',
    'Bulgarian',
    'Catalan',
    'Cambodian',
    'Chinese (Mandarin)',
    'Croatian',
    'Czech',
    'Danish',
    'Dutch',
    'English',
    'Estonian',
    'Fiji',
    'Finnish',
    'French',
    'Georgian',
    'German',
    'Greek',
    'Gujarati',
    'Hebrew',
    'Hindi',
    'Hungarian',
    'Icelandic',
    'Indonesian',
    'Irish',
    'Italian',
    'Japanese',
    'Javanese',
    'Korean',
    'Latin',
    'Latvian',
    'Lithuanian',
    'Macedonian',
    'Malay',
    'Malayalam',
    'Maltese',
    'Maori',
    'Marathi',
    'Mongolian',
    'Nepali',
    'Norwegian',
    'Persian',
    'Polish',
    'Portuguese',
    'Punjabi',
    'Quechua',
    'Romanian',
    'Russian',
    'Samoan',
    'Serbian',
    'Slovak',
    'Slovenian',
    'Spanish',
    'Swahili',
    'Swedish',
    'Tamil',
    'Tatar',
    'Telugu',
    'Thai',
    'Tibetan',
    'Tonga',
    'Turkish',
    'Ukrainian',
    'Urdu',
    'Uzbek',
    'Vietnamese',
    'Welsh',
    'Xhosa'
  ]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable, :validatable,
         omniauth_providers: [:linkedin]

  extend Memoist
  include OldAppDataMigration if ENV['OLD_DATA_MIGRATION_COMPATIBILITY_MODE']

  # Callbacks
  ###########

  before_save :clean_array_attributes

  # Validations
  #############

  validates :email,
            presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  # validates :date_of_birth, inclusion: {
  #   in: Date.new(1900)..Time.zone.today,
  #   message: 'must be between 1900 and today'
  # }, allow_nil: true
  validates :terms_of_service, acceptance: { message: 'must be abided' }


  # only validate this on update, which means those validations will not run
  # for registrations (ie : Apply)
  validates :first_name,
              presence: {
                on: :update,
                unless: -> { skip_first_name_validation == '1' }
              }
  validates :last_name,
              presence: {
                on: :update,
                unless: -> { skip_last_name_validation == '1' }
              }
  validates :civility,
              presence: {
                on: :update,
                unless: -> { skip_civility_validation == '1' }
              }
  validates :country,
              presence: {
                on: :update,
                unless: -> { skip_country_validation == '1' }
              }
  # validates :city,
  #             presence: {
  #               on: :update,
  #               unless: -> { skip_city_validation == '1' }
  #             }
  validates :position,
              presence: {
                on: :update,
                unless: -> { skip_position_validation == '1' }
              }
  validates :website,
              presence: {
                on: :update,
                unless: -> { skip_website_validation == '1' }
              }

  # validates :turnover,
  #           presence: {
  #             on: :update,
  #             unless: -> { skip_turnover_validation == '1' }
  #           }

  # validates :staff_volume,
  #           presence: {
  #             on: :update,
  #             unless: -> { skip_staff_volume_validation == '1' }
  #           }

  validates :international_activity_countries,
            presence: {
              on: :update,
              unless: -> { password_confirmation.present? || skip_international_activity_countries_validation == "1"}
            }

  validate :presence_of_business_sectors,  on: :update

  mount_uploader :avatar, AvatarUploader
  mount_uploader :company_logo, CompanyLogoUploader

  # Associations
  ##############

  has_many :user1_connections, foreign_key: 'user1_id', class_name: 'Connection'
  has_many :user2_connections, foreign_key: 'user2_id', class_name: 'Connection'

  has_many :sent_connection_demands,
           foreign_key: 'user1_id', class_name: 'ConnectionDemand'
  has_many :received_connection_demands,
           foreign_key: 'user2_id', class_name: 'ConnectionDemand'

  has_many :proposed_connections,
           foreign_key: 'user1_id', class_name: 'ConnectionProposition'
  has_many :forwarded_proposed_connections,
           foreign_key: 'user2_id', class_name: 'ConnectionProposition'

  has_many :connection_requests, foreign_key: 'author_id'

  has_many :feedbacks, foreign_key: 'author_id'
  has_many :posts, class_name: 'BeeleeverPost', foreign_key: 'author_id'

  include Shop

  # State machine
  ###############

  include AASM

  aasm column: :status do
    state :activation_pending, initial: true
    state :active
    state :rejected
    state :account_deleted

    event :activate do
      after do
        update_attribute :activated_at, Time.zone.now

        instance_variable_set :@user1, self
        sender = EmailTemplateSender.new('after-activate-user', self)
        sender.after(self)
      end

      transitions from: :activation_pending, to: :active
    end

    event :reject do
      after do
        instance_variable_set :@user1, self
        sender = EmailTemplateSender.new('after-reject-user', self)
        sender.after(self)
      end

      transitions from: :activation_pending, to: :rejected
    end

    event :delete_account do
      after do
        instance_variable_set :@user1, self
        sender = EmailTemplateSender.new('after-delete-account', self)
        sender.after(self)
        anonymise_attributes(self)
        self.save validate: false
      end

      transitions from: :activation_pending, to: :account_deleted
      transitions from: :rejected,           to: :account_deleted
      transitions from: :active,             to: :account_deleted
    end
  end

  # Class methods
  ###############

  class << self
    def ordered_by_name
      t = arel_table
      order_1 = t[:last_name].lower
      order_2 = t[:first_name].lower
      order(order_1, order_2)
    end

    # Find a user with the OAuth provided auth info
    #
    # First, tries to find a user by email (case insensitive) with the
    #   auth.info.email If found, updates the following user's attributes and
    #   saves the user :
    #     - provider (only 'linkedin' here)
    #     - uid (linkedin internal user id)
    #     - fetch the linkedin's avatar and set it on the user
    #     - the linkedin public profile url
    #
    # If no user could be found by email, try to find a user by 'provider' and
    # 'uid' attributes
    #
    # If found, returns the user
    #
    # If not found creates a user and sets its attributes with the auth info
    # also set the user's password with Devise.friendly_token to avoid
    # validation errors
    #
    # @param auth [OmniAuth::AuthHash] OAuth info object
    # @return [User] the user found with the auth info
    def find_for_oauth(auth)

      if (user = where(arel_table[:email].matches(auth.info.email)).first)
        user.provider = auth.provider
        user.uid = auth.uid
        user.remote_avatar_url = auth.info.image unless user.avatar?
        user.provider_public_profile_url ||= auth.info.urls.public_profile
        user.save
      else
        user = where(auth.slice(:provider, :uid)).first_or_create do |u|
          u.provider = auth.provider
          u.uid = auth.uid
          u.email = auth.info.email
          u.first_name = auth.info.first_name
          u.last_name = auth.info.last_name
          u.remote_avatar_url = auth.info.image
          u.provider_public_profile_url = auth.info.urls.public_profile
          u.password = Devise.friendly_token.first(8)
        end
      end

      user
    end

    # Scope to be used for activate_user reminder emails
    #
    # Applies the following scopes :
    #
    # - active
    # - activated_at <= 7.days.ago
    # - active_user_reminder_count < 1
    # - phone_interview_realized == false
    #
    # @return [ActiveRecord::Relation]
    def for_activate_user_reminder
      active
        .where(arel_table[:activated_at].lteq(7.days.ago))
        .where(arel_table[:activate_user_reminder_count].lt(1))
        .where(phone_interview_realized: false)
    end

  end

  # Attributes
  ############

  attr_accessor :terms_of_service
  attr_accessor :skip_turnover_validation
  attr_accessor :skip_staff_volume_validation
  attr_accessor :skip_first_name_validation
  attr_accessor :skip_last_name_validation
  attr_accessor :skip_civility_validation
  attr_accessor :skip_title_validation
  attr_accessor :skip_country_validation
  attr_accessor :skip_city_validation
  attr_accessor :skip_position_validation
  attr_accessor :skip_website_validation
  attr_accessor :skip_international_activity_countries_validation
  attr_accessor :skip_business_sectors_validation

  # Instance methods
  ##################

  def name
    [first_name, last_name].join(' ').titleize
  end

  def male?
    %w(Mr. Dr.).include?(civility)
  end

  def female?
    %w(Mrs. Ms.).include?(civility)
  end

  def expert?
    profil == 'Expert'
  end

  def local_partner?
    profil == 'Local Partner'
  end

  def connected_user_ids
    (
      user1_connections.live.pluck(:user2_id) +
      user2_connections.live.pluck(:user1_id)
    ).uniq
  end
  memoize :connected_user_ids

  def connected_users
    self.class.where(id: connected_user_ids)
  end

  def to_liquid
    UserDrop.new self
  end

  # Increment the activate_user_reminder_count attribute value and find the
  # corresponding "after-activate-user-reminder-X" template, renders and sends
  # the template and save the record
  #
  # @return [Boolean]
  def send_activate_user_reminder_email
    # find the email template corresponding to the
    # incremented_reminder_count
    template = EmailTemplate.find_by_name(
      "after-activate-user-reminder-#{self.activate_user_reminder_count}"
    )

    # do noting if no template could be found
    return unless template

    # set the liquid template options
    template_options = { 'user1' => self }

    # render the template and deliver it
    ApplicationMailer.email_template(template, self, template_options).deliver

    # update the new activate_user_reminder_count attribute
    update_column :activate_user_reminder_count, 1
  end

  # we override Devise::Recoverable#reset_password! here to allow password reset
  # even if turnover and staff_volume attributes are missing
  def reset_password!(new_password, new_password_confirmation)
    self.skip_turnover_validation = '1'
    self.skip_staff_volume_validation = '1'
    super
  end

  def beeleev_staff?
    email =~ /beeleev.com$/
  end

  def website_uri
    return unless website.present?

    uri = URI(website)
    uri = URI::HTTP.build(host: uri.to_s) if uri.instance_of?(URI::Generic)
    uri
  rescue URI::InvalidURIError
    nil
  end

  def anonymise_attributes(user)
    user.first_name = "unavailable"
    user.last_name =  ""
    user.email =  "#{rand(1.0...100000.0)}@unavailable.com"
    user.provider =  ""
    user.uid =  ""
    user.remove_avatar!
    user.week =  ""
    user.sponsor =  ""
    user.source =  ""
    user.profil =  "-"
    user.prospects =  ""
    user.civility =  ""
    user.nationalite =  ""
    user.city =  ""
    user.country =  ""
    user.cellphone =  ""
    user.position =  ""
    user.company =  ""
    user.activities_1 =  ""
    user.activities_2 =  ""
    user.turnover =  ""
    user.staff_volume =  ""
    user.website =  ""
    user.url_profile =  ""
    user.meeting_form =  ""
    user.provider_public_profile_url =  nil #LinkedIn
    user.password =  "1234554321"
    user.phone =  ""
    user.twitter_account =  nil
    user.skype_account =  nil
    user.spoken_languages =  []
    user.expertises =  []
    user.date_of_birth =  ""
    user.entrepreneur_clubs =  ""
    user.investment_activity =  false
    user.year_of_creation =  ""
    user.description =  ""
    user.tagline =  ""
    user.business_model =  ""
    user.international_activity =  false
    user.international_activity_countries =  []
    user.growth_rate =  ""
    user.current_customers =  ""
    user.current_partners =  ""
    user.hiring_objectives =  false
    user.phone_interview_realized =  false
    user.new_application_reminder_count =  0
    user.application_reject_reason =  ""
    user.business_sectors =  []
    user.investment_levels =  []
    user.company_description =  ""
    user.facebook_username =  nil
    user.remove_company_logo!
    user.company_twitter_account = ""
    user.company_facebook_account = ""
    user.company_linkedin_account = ""
    return user
  end

  private

  # Strip blank values from :spoken_languages, :expertises,
  # :international_activity_countries, :business_sectors and :investment_levels
  #
  # See http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select-label-Gotcha
  # to understand why forms for these attributes send blank values
  def clean_array_attributes
    [
      :spoken_languages,
      :expertises,
      :international_activity_countries,
      :business_sectors,
      :investment_levels
    ].each do |attribute|
      # get the current attribute value
      value = send(attribute)

      # set the new value after rejecting blank? elements. if the value is nil,
      # replace it with an empty array, which is the default for Array
      # attributes
      send "#{attribute}=", (value || []).reject(&:blank?)
    end
  end

  # Make sure at least 1 business sector is present
  def presence_of_business_sectors
    errors.add(:business_sectors, "can't be blank") \
    if business_sectors.all?(&:blank?) && self.skip_business_sectors_validation != "1"
  end


end
