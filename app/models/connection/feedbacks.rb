class Connection
  module Feedbacks

    extend ActiveSupport::Concern

    included do

      # Associations
      ##############

      has_many :feedbacks

    end

    # Feedback for user1
    #
    # @return [Feedback]
    def user1_feedback
      feedbacks.detect {|f| f.author_id == user1_id}
    end

    # Feedback for user2
    #
    # @return [Feedback]
    def user2_feedback
      feedbacks.detect {|f| f.author_id == user2_id}
    end

    # false if both feedbacks have been filled
    # true otherwise
    #
    # @return [Boolean]
    def feedback_missing?
      user1_feedback.nil? || user2_feedback.nil?
    end

  end
end
