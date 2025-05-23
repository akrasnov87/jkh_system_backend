ActiveAdmin.register Notification, namespace: :admin do
  menu priority: 5, parent: 'Информация по УК'
  permit_params :company, :image, :title, :body, :active, :whodunit, :kind, :house, :url_action,
                attachments_attributes: %i(id kind file _destroy)
  batch_action :destroy, false

  controller do
    def scoped_collection
      if params[:action] == "edit"
        Notification.where(company: current_user.companies << nil).includes(attachments: [file_attachment: :blob])
      else
        Notification.where(company: current_user.companies << nil)
      end
    end
  end

  filter :company, as: :select, collection: proc {
                                              current_user.companies.compact.map do |k|
                                                [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
                                              end
                                            }
  filter :body
  filter :title

  index do
    column :id
    column :active
    column :kind do |notification|
      I18n.t("notifications.kinds.#{notification.kind}")
    end
    column :company do |notification|
      I18n.t("companies.#{notification.company}") if notification.company
    end
    column :image do |notification|
      image_tag("#{notification.image}.svg", size: 30)
    end
    column :title
    column :house
    column :url_action do |notification|
      I18n.t("notifications.url_actions.#{notification.url_action}") if notification.url_action
    end
    column :actions do |notification|
      links = []
      links << link_to('Открыть', admin_notification_path(notification)) unless notification.general?
      links << link_to('Изменить', edit_admin_notification_path(notification)) unless notification.general?
      links << link_to('Удалить', admin_notification_path(notification), method: :delete, confirm: 'Are you sure?') unless notification.general?
      links.join(' ').html_safe
    end
  end

  show do
    attributes_table do
      row :active
      row :kind do |notification|
        I18n.t("notifications.kinds.#{notification.kind}")
      end
      row :company do |notification|
        I18n.t("companies.#{notification.company}") if notification.company
      end
      row :image do |notification|
        image_tag("#{notification.image}.svg", size: 40)
      end
      row :title
      row :body
      row :house
      row :url_action do |notification|
        I18n.t("notifications.url_actions.#{notification.url_action}") if notification.url_action
      end
      row :icons do |notification|
        notification.icons.map do |icon|
          image_tag url_for(icon.file), size: "50x50"
        end
      end
      row :news_images do |notification|
        notification.news_images.map do |news_image|
          image_tag url_for(news_image.file), size: "200x200"
        end
      end
      row :whodunit
      row :created_at
      row :updated_at
      row :attachments do |notification|
        notification.attachments.map do |attachment|
          link_to(attachment.file.filename, attachment.url)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :active
      f.input :kind, as: :select,
                     collection: [[I18n.t('notifications.kinds.personal_company'), :personal_company],
                                  [I18n.t('notifications.kinds.personal_house'), :personal_house]],
                     include_blank: false
      f.input :house, as: :select,
                      collection: Account.where(company: current_user.companies).pluck(:house).uniq,
                      include_blank: false, input_html: { multiple: false, data: { controller: 'slim' } }
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] },
                        required: true
      f.inputs do
        "
        <li class='radio input required' id='notification_image_input'><fieldset class='choices'>
         <legend class='label'><label>Картинки</label></legend>
         <ul class='flex flex-wrap items-center justify-center text-gray-900 dark:text-white'>
          #{notification_html_images_options}
         </ul>
         ".html_safe
      end
      f.input :title
      f.input :body
      f.input :url_action, as: :select, collection: Notification.url_actions.map { |k, _v| [I18n.t("notifications.url_actions.#{k}"), k] }
      f.input :whodunit, input_html: { value: current_user.email }, as: :hidden
      f.has_many :attachments, allow_destroy: true do |a|
        a.input :kind, label: 'Где разместить картинку',as: :select, collection: Attachment.kinds.map { |k, _v| [I18n.t("attachments.kinds.#{k}"), k] }, include_blank: false
        a.input :file, as: :file, hint: a.object.file.present? ? a.object.file.filename.to_s : content_tag(:span, '')
      end
    end
    f.actions
  end
end
