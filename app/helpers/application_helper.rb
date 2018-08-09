module ApplicationHelper
  def icon_tag(name, options = {})
    if dom_class = options[:class]
      dom_class = ' ' << dom_class
    end

    case name
    when /\Aglyphicon-/
      "<span class='glyphicon #{name}#{dom_class}'></span>".html_safe
    when /\Afa-/
      "<i class='fa #{name}#{dom_class}'></i>".html_safe
    else
      raise "Unrecognized icon name: #{name}"
    end
  end

  # sort by <th>
  def sortable(column, title=nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction]) == 'asc' ? 'desc' : 'asc'
    link_to title, sort: column, direction: direction
  end
end
