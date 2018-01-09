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

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email,
            presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :date_of_birth, inclusion: {
    in: Date.new(1900)..Time.zone.today,
    message: 'must be between 1900 and today'
  }, allow_nil: true

  # only validate this on update, which means those validations will not run
  # for registrations (ie : Apply)
  validates_presence_of :civility,                         on: :update
  validates_presence_of :country,                          on: :update
  validates_presence_of :city,                             on: :update
  validates_presence_of :position,                         on: :update
  validates_presence_of :website,                          on: :update

  validates :turnover,
            presence: {
              on: :update,
              unless: -> { skip_turnover_validation == '1' }
            }

  validates :staff_volume,
            presence: {
              on: :update,
              unless: -> { skip_staff_volume_validation == '1' }
            }

  validates :international_activity_countries,
            presence: {
              on: :update,
              unless: -> { password_confirmation.present? }
            }

  validate :presence_of_business_sectors,  on: :update

  mount_uploader :avatar, AvatarUploader

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
        # raise user.inspect
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

  attr_accessor :skip_turnover_validation
  attr_accessor :skip_staff_volume_validation

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
    if business_sectors.all?(&:blank?)
  end

end
