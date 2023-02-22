# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module TransparentTrash
    module Extends
      # module: decidim-initiatives
      # path: decidim-initiatives/app/permissions/decidim/initiatives/admin/permissions.rb
      module InitiativesAdminPermissions
        extend ActiveSupport::Concern

        included do
          # rubocop:disable Metrics/CyclomaticComplexity
          # rubocop:disable Metrics/PerceivedComplexity
          # Allow when action is unpublish and initiative is published, invalidated or illegal
          def initiative_admin_user_action?
            return unless permission_action.subject == :initiative

            case permission_action.action
            when :read
              toggle_allow(Decidim::Initiatives.print_enabled)
            when :publish, :discard
              toggle_allow(initiative.validating?)
            when :unpublish
              toggle_allow(initiative.published? || initiative.invalidated? || initiative.illegal?)
            when :export_pdf_signatures
              toggle_allow(initiative.published? || initiative.accepted? || initiative.rejected?)
            when :export_votes
              toggle_allow(initiative.offline_signature_type? || initiative.any_signature_type?)
            when :accept
              allowed = initiative.published? &&
                        initiative.signature_end_date < Date.current &&
                        initiative.supports_goal_reached?
              toggle_allow(allowed)
            when :reject
              allowed = initiative.published? &&
                        initiative.signature_end_date < Date.current &&
                        !initiative.supports_goal_reached?
              toggle_allow(allowed)
            when :send_to_technical_validation
              toggle_allow(allowed_to_send_to_technical_validation?)
            else
              allow!
            end
          end
          # rubocop:enable Metrics/CyclomaticComplexity
          # rubocop:enable Metrics/PerceivedComplexity
        end
      end
    end
  end
end
