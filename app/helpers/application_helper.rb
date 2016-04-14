module ApplicationHelper
  def menu_settings
    content_tag :li, link_to(fa_icon('heart', text: 'Treatments'), root_path)
  end

  def default_gravatar
    gravatar_image_tag(
      'junk',
      alt: 'Github Default Gravatar',
      gravatar: { default: 'https://assets.github.com/images/gravatars/gravatar-140.png', size: 50 },
      class: 'img-rounded')
  end

  def gravatar_for(user, size = 50, title = user.username)
    image_tag gravatar_image_url(user.email, size: size), title: title, class: 'img-rounded'
  end

  def recipients_options(chosen_recipient = nil)
    s = ''
    Pro.all.each do |user|
      s << "<option value='#{user.username} #{user.id}' data-img-src='#{gravatar_image_url(user.email, size: 30)}' #{'selected' if user == chosen_recipient}>#{user.username}</option>"
    end
    s.html_safe
  end
end
