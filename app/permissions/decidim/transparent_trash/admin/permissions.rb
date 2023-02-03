# frozen_string_literal: true

module Decidim
  module TransparentTrash
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin
          return permission_action unless user&.admin?

          allow! if can_access?

          permission_action
        end

        def can_access?
          permission_action.subject == :transparent_trash &&
            permission_action.action == :read
        end
      end
    end
  end
end
