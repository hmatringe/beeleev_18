class EventPostsController < ApplicationController

  layout 'website'

  # GET /news
  #
  # Fetch published posts orderedby "publication_date desc"
  def index
    @posts = resource_collection.order('publication_date desc')
  end

  def index_18
    @posts = resource_collection.order('publication_date desc')
  end

  def show
    @post = EventPost.find params[:id]

    redirect_to '/news' and return if cannot?(:read, @post)
  end

  private

  def resource_collection
    EventPost.published
  end

  # should the first post be illustrated on the left or on the right
  #
  # This is necessary to make sure a given post will always be illustrated on
  # the same side, no matter how many posts we have to display
  #
  # @return ['left', 'right']
  def illustration_cycle_values
    if resource_collection.count.even?
      ['left', 'right']
    else
      ['right', 'left']
    end
  end
  helper_method :illustration_cycle_values

end
