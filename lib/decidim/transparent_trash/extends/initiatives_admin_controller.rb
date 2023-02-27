# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module TransparentTrash
    module Extends
      # module: decidim-initiatives
      # path: decidim-initiatives/app/controllers/decidim/initiatives/admin/initiatives_controller.rb
      module InitiativesAdminController
        extend ActiveSupport::Concern

        included do
          # Add Transparent trash admin permissions
          def permission_class_chain
            super + [Decidim::TransparentTrash::Admin::Permissions]
          end

          # DELETE /admin/initiatives/:id/invalidate
          def invalidate
            enforce_permission_to :invalidate, :initiative, initiative: current_initiative

            Decidim::Initiatives::Admin::InvalidateInitiative.call(current_initiative, current_user) do
              on(:ok) do
                flash[:notice] = I18n.t("initiatives.update.success", scope: "decidim.initiatives.admin")
                redirect_to decidim_admin_initiatives.edit_initiative_path(current_initiative)
              end
              on(:invalid) do
                redirect_to decidim_admin_initiatives.edit_initiative_path(current_initiative)
              end
            end
          end

          # DELETE /admin/initiatives/:id/illegal
          def illegal
            enforce_permission_to :illegal, :initiative, initiative: current_initiative

            Decidim::Initiatives::Admin::IllegalInitiative.call(current_initiative, current_user) do
              on(:ok) do
                flash[:notice] = I18n.t("initiatives.update.success", scope: "decidim.initiatives.admin")
                redirect_to decidim_admin_initiatives.edit_initiative_path(current_initiative)
              end
              on(:invalid) do
                redirect_to decidim_admin_initiatives.edit_initiative_path(current_initiative)
              end
            end
          end
        end
      end
    end
  end
end
