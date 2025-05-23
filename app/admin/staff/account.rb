ActiveAdmin.register Account, namespace: :staff do
  menu false
  permit_params :phone

  controller do
    def scoped_collection
      Account.includes(counters: :counters_values)
    end
  end

  index download_links: false do
    selectable_column
    id_column
    column :number
    column :date_begin
    column :date_end
    column :address
    column :full_name
    column :company
  end

  filter :number
  filter :date_begin
  filter :date_end
  filter :address
  filter :full_name
  filter :company
  filter :phone
end
