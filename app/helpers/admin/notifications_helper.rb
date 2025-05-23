module Admin
  module NotificationsHelper
    def notification_html_images_options
      Notification.images.map do |k, _v|
        "<div class='flex items-center ps-4 border border-gray-200 rounded dark:border-gray-700'>
          <li class='choice'><label for='notification_image_#{k}'>
          <input id='notification_image_#{k}' type='radio' value=#{k} name='notification[image]'>#{image_tag("#{k}.svg", size: 40)}</label></li>
        </div>"
      end.join('')
    end
  end
end
