module ApplicationHelper

  # proxy to I18n.l that handles nil args
  def ldate(dt, hash = {})
    dt ? l(dt, hash) : nil
  end

  def menu_link(name, url)
    classes = []
    classes << 'active' if url == request.fullpath
    link = link_to name, url, class: classes, role: 'button'
    content_tag(:li, link )
  end

  # Equivalent to Float#ceil, but instead of returning the smallest integer
  # greater than or equal to the Float receiver, it will use an Integer receiver
  # and ceil it to the roof param
  #
  # ex: retourner la cinquantaine au dessus :
  # ceil_to(445, 50) # => 450
  # ceil_to(1005, 100) # => 1100
  #
  # @param value [Integer] the Integer to be ceiled
  # @param roof [Integer] arrondi supérieur souhaité
  # @return [Integer] the ceiled value
  def ceil_to(value, roof)
    (value.to_f / roof).ceil * roof
  end

  def fb_like_button(url, data)
    link_to '', url, class: 'fb-like', data: data
  end

end
