module ApplicationHelper
  def menu_settings
    content_tag :li, link_to(fa_icon('heart', text: 'Treatments'), root_path)
  end
end
