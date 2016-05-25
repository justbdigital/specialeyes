module ApplicationHelper
  COUNTRIES = ['United Kingdom', 'Sweden'].freeze
  TREATTYPE = ['Eyelash and Eyebrow Treatments', 'Eyelash Extentions', 'New Treatment', 'Old Treatment', 'First', 'Last'].freeze
  TYPES = ['Mobile Beauty', 'Medical Spa'].freeze
  AMOUNTS = { 10 => '£ 10.00', 20 => '£ 20.00', 30 => '£ 30.00', 40 => '£ 40.00', 50 => '£ 50.00', 60 => '£ 60.00',
              70 => '£ 70.00', 80 => '£ 80.00', 90 => '£ 90.00', 100 => '£ 100.00' }.freeze
  DURATIONS = { 1 => '30 min', 2 => '1 h', 3 => '1 h 30 min', 4 => '2 h', 5 => '2 h 30 min', 6 => '3 h', 7 => '3 h 30 min',
                8 => '4 h', 9 => '4 h 30 min', 10 => '5 h', 11 => '5 h 30 min', 12 => '6 h', 13 => '6 h 30 min', 14 => '7 h',
                15 => '7 h 30 min', 16 => '8 h', 17 => '8 h 30 min', 18 => '9:00', 19 => '9:30', 20 => '10:00', 21 => '10:30',
                22 => '11:00', 23 => '11:30', 24 => '12:00', 25 => '12:30', 26 => '13:00', 27 => '13:30', 28 => '14:00', 29 => '14:30',
                30 => '15:00', 31 => '15:30', 32 => '16:00', 33 => '16:30', 34 => '17:00', 35 => '17:30', 36 => '18:00', 37 => '18:30',
                38 => '19:00', 39 => '19:30', 40 => '20:00' }.freeze
  WEEK = { 1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday', 4 => 'Thursday', 5 => 'Friday', 6 => 'Saturday', 7 => 'Sunday' }.freeze
  SLOTS = { 1 => '00:30', 2 => '01:00', 3 => '01:30', 4 => '02:00', 5 => '02:30', 6 => '03:00', 7 => '03:30',
            8 => '04:00', 9 => '04:30', 10 => '05:00', 11 => '05:30', 12 => '06:00', 13 => '06:30', 14 => '07:00',
            15 => '07:30', 16 => '08:00', 17 => '08:30', 18 => '9:00', 19 => '9:30', 20 => '10:00', 21 => '10:30',
            22 => '11:00', 23 => '11:30', 24 => '12:00', 25 => '12:30', 26 => '13:00', 27 => '13:30', 28 => '14:00', 29 => '14:30',
            30 => '15:00', 31 => '15:30', 32 => '16:00', 33 => '16:30', 34 => '17:00', 35 => '17:30', 36 => '18:00', 37 => '18:30',
            38 => '19:00', 39 => '19:30', 40 => '20:00', 41 => '20:30', 42 => '21:00', 43 => '21:30', 44 => '22:00', 45 => '22:30',
            46 => '23:00', 47 => '23:30', 48 => '00:00' }.freeze

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

  def venue_image(venue)
    venue.image.blank? ? image_tag("#{venue.id % 3}.jpg", width: 200) : image_tag(venue.image_url)
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
