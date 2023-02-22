# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module TransparentTrash
    module Extends
      # module: decidim-initiatives
      # path: decidim-initiatives/app/permissions/decidim/initiatives/initiatives_permissions.rb
      module InitiativesPermissions
        extend ActiveSupport::Concern

        included do
          # rubocop:disable Metrics/CyclomaticComplexity
          # Allows to read invalidated and illegal initiatives
          def read_public_initiative?
            return unless [:initiative, :participatory_space].include?(permission_action.subject) &&
                          permission_action.action == :read

            return allow! if initiative.published? || initiative.rejected? || initiative.accepted?
            return allow! if initiative.invalidated? || initiative.illegal?
            return allow! if user && authorship_or_admin?

            disallow!
          end
          # rubocop:enable Metrics/CyclomaticComplexity
        end
      end
    end
  end
end
