ActiveAdmin.register Push, namespace: :super_admin do
  menu priority: 100
  permit_params :number, :name

  controller do
    def scoped_collection
      Push.includes(:user)
    end
  end
end
