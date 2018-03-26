class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/bryanrite/cancancan/wiki/Defining-Abilities

    if user
      can :see_private_profile, User do |other_user|
        user == other_user ||
          (user.present? && user.connected_user_ids.include?(other_user.id))
      end

      can :create, ConnectionDemand do |cd|
        user.id != cd.user2_id
      end unless user.expert?

      # TODO original: delete after exhaustive tests
      # can [
      #   :access_network, :access_activity, :access_my_network,
      #   :see_new_connection_request_button
      # ], User, status: 'active'
      # TODO refactor: destroy always true policies after exhaustive tests with client
      can [
        :access_activity
        #,:see_new_connection_request_button
      ], User, status: 'activation_pending'
      
      can [
        :access_network,
        :access_activity,
        :access_my_network,
        :see_new_connection_request_button
      ], User, status: 'active'

      if can?(:see_new_connection_request_button, user)
        can :create, ConnectionRequest
      end

      if user.can_post?
        can :create, BeeleeverPost
        can :create, Comment
      end

      if user.beeleev_staff?
        can :share, "Video"
      end

      if user.email == 'julien@crx.io'
        can :share, "Video"
      end

    end

    can :read, Post do |post|
      post.detailed_body.present? && post.published?
    end
  end
end
