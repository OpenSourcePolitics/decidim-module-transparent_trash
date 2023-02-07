# frozen_string_literal: true

module Decidim
  module TransparentTrash
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin
          return permission_action unless user&.admin?

          allow! if can_access?
          initiative_admin_user_action?

          permission_action
        end

        def can_access?
          permission_action.subject == :transparent_trash &&
            permission_action.action == :read
        end

        def initiative_admin_user_action?
          return unless permission_action.subject == :initiative

          case permission_action.action
          when :invalidate, :illegal
            toggle_allow(initiative.validating?)
          end
        end

        def initiative
          @initiative ||= context.fetch(:initiative, nil) || context.fetch(:current_participatory_space, nil)
        end
      end
    end
  end
end
