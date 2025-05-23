ActiveAdmin.register Push, namespace: :admin do
  menu priority: 4, parent: 'Уведомления'

  controller do
    def scoped_collection
      Push.includes(:user)
    end
  end
end
