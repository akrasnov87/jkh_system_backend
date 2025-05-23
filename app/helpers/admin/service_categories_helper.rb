module Admin
  module ServiceCategoriesHelper
    def html_images_options
      ServiceCategory.images.map do |k, _v|
        "<div class='flex items-center ps-4 border border-gray-200 rounded dark:border-gray-700'>
          <li class='choice'><label for='service_category_image_#{k}'>
          <input id='service_category_image_#{k}' type='radio' value=#{k} name='service_category[image]'>#{image_tag("#{k}.svg",
                                                                                                                     size: 40)}</label></li>
        </div>"
      end.join('')
    end
  end
end
