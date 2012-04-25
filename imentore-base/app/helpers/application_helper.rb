module ApplicationHelper
  include ActionView::Helpers

  def breadcrumb(array)
    output = '
    <ul class="breadcrumb">'
    size = array.size - 1
    array.each {
      |e| e.each {
        |key, value|
        if value.empty?
          output += key
        else
          output << content_tag(:li)
          output += link_to(key, value)
        end
        output += " > " if size > 0
      }
      size -= 1
    }
    output += '</ul>
    '
    return output
  end

  def url(params)
    case params
    when 'login'
      "/users/login"
    end
  end

  def asset_url(name)
    # binding.pry
  end



end
