module ApplicationHelper
  def menu_settings
    content_tag :li, link_to(fa_icon('heart', text: 'Treatments'), treatments_path)
  end

  def rating_stars(venue)
    stars = venue.rating
    (1..5).to_a.inject([]) do |memo, index|
      if index <= stars.to_i
        memo << fa_icon('star')
      elsif stars.to_f > stars.to_i && index == stars.to_i + 1
        memo << fa_icon('star-half-o')
      else
        memo << fa_icon('star-o')
      end
      memo
    end.join('').html_safe
  end

  def pro_header?
    request.env['PATH_INFO'].match('pro')
  end

  def login_name
    if current_user.is_a? Pro
      "#{current_user.email} (signed in as pro)"
    else
      current_user.try(:profile_name) || current_user.email
    end
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

  def check_venue_path
    current_user.venue ? edit_venue_path(current_user.venue) : new_venue_path(Venue.new)
  end

  def check_balance_path
    if current_user.balance
      link_to(fa_icon('gift', text: 'Gifts'), gifts_balance_path, method: :get)
    else
      link_to(fa_icon('gift', text: 'Gifts'), balance_path, method: :post)
    end
  end

  def check_account_path
    current_user.bank_account ? edit_bank_account_path(current_user.bank_account) : new_bank_account_path(BankAccount.new)
  end
end
