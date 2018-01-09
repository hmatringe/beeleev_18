class User
  module Shop

    extend ActiveSupport::Concern

    included do
      has_many :orders
      has_many :connection_credits
    end

    # @return [ConnectionCredit]
    #
    # The next ConnectionCredit that will be used for a connection
    #
    # Selects the usable? connection_credits, orders them by created_at: :asc
    # and returns the first record
    def next_usable_connection_credit
      connection_credits.find_all(&:usable?).sort_by(&:created_at).first
    end

  end
end
