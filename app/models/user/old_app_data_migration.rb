class User

  # Module only included in the User class if
  # ENV["OLD_DATA_MIGRATION_COMPATIBILITY_MODE"] is set
  #
  # Defines a series of methods to make this old app data from xls file easier
  module OldAppDataMigration

    extend ActiveSupport::Concern

    included do
      before_save :set_created_at
    end

    # Constants
    ###########
    EXPERTISES_VALUES = EXPERTISES.values.flatten

    # Callbacks
    ###########

    alias_attribute :skype, :skype_account
    alias_attribute :twitter, :twitter_account
    alias_attribute :creation_date, :year_of_creation
    alias_attribute :clubs_and_associations, :entrepreneur_clubs

    attr_writer :year, :week

    def year
      @year.to_i
    end

    def week
      @week.to_i
    end

    # Define User#expertise_1=, User#expertise_2=, User#expertise_3=
    (1..3).each do |i|
      define_method "expertise_#{i}=" do |exp|
        return if exp.blank?
        raise exp.inspect unless EXPERTISES_VALUES.include? exp
        self.expertises[i-1] = exp
      end
    end

    # Define User#international_activity_country_name_1=,
    # User#international_activity_country_name_2=,
    # User#international_activity_country_name_3=
    (1..3).each do |i|
      define_method "international_activity_country_name_#{i}=" do |country|
        return if country.blank?
        self.international_activity = true
        self.international_activity_countries[i-1] = country
      end
    end

    def language=(lang)
      return if lang.blank?
      raise lang.inspect unless LANGUAGES.include? lang
      self.spoken_languages[0] = lang
    end

    private

    def set_created_at
      return unless year && week
      self.created_at = Date.new(year) + week.weeks
    end

    # used by devise to know if it should validate password presence
    #
    # We override it here becose for data seeds, we do not want this validation
    # to run
    def password_required?
      false
    end

  end
end
