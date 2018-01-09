module EventPostsHelper

  # Renders the "posts/post_row" partial
  #
  # Places the illustration either on the left column or on the right column
  def post_row(post, illustration_column)

    illustration_markup = post_illustration_markup post
    text_markup         = post_text_markup post

    case illustration_column
    when 'left'
      left_markup  = illustration_markup
      right_markup = text_markup
    when 'right'
      left_markup  = text_markup
      right_markup = illustration_markup
    end

    render 'event_posts/post_row',
      post: post,
      left_markup: left_markup,
      right_markup: right_markup

  end

  def post_illustration_markup(post)
    cl_image_tag post.illustration.full_public_id,
                 fetch_format: :auto,
                 width: 555,
                 crop: :fill,
                 quality: 80,
                 class: 'img-responsive'
  end

  def post_text_markup(post)
    text_markup =
      content_tag(:h2, post.title) +
      content_tag(:h2, post.subtitle.html_safe, class: 'suite') +
      content_tag(:p, post.body.html_safe)

    if can? :read, post
      link = link_to('Read more &hellip;'.html_safe, post)
      text_markup += content_tag(:p, link)
    end

    text_markup += fb_like_button events_url(anchor: post.id),
                                  layout: 'button'

    text_markup
  end

end
