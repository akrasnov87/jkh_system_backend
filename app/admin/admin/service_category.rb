ActiveAdmin.register ServiceCategory, namespace: :admin do
  permit_params :name, :image, :company, :position
  menu priority: 9, parent: 'Услуги'
  batch_action false

  controller do
    def scoped_collection
      ServiceCategory.where(company: current_user.companies)
    end
  end

  filter :company, as: :select, collection: proc {
    current_user.companies.compact.map do |k|
      [I18n.t("companies.#{k}"), CompanyDetail::COMPANY[k.to_sym]]
    end
  }

  index do
    id_column
    column :name
    column :company do |service_category|
      I18n.t("companies.#{service_category.company}")
    end
    column :position
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :company do |service_category|
        I18n.t("companies.#{service_category.company}")
      end
      row :name
      row :image do |notification|
        image_tag("#{notification.image}.svg", size: 40)
      end
      row :position
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :position
      f.inputs do
        "
        <li class='radio input required' id='notification_image_input'><fieldset class='choices'>
         <legend class='label'><label>Картинки</label></legend>
         <ul class='flex flex-wrap items-center justify-center text-gray-900 dark:text-white'>
          #{html_images_options}
         </ul>
         ".html_safe
      end
      f.input :company, as: :select, collection: current_user.companies.map { |k| [I18n.t("companies.#{k}"), k] }
    end
    f.actions
  end
end
