# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module TransparentTrash
    module Extends
      # module: decidim-initiatives
      # path: decidim-initiatives/app/commands/decidim/initiatives/admin/unpublish_initiative.rb
      module UnpublishInitiative
        extend ActiveSupport::Concern

        included do
          # Executes the command. Broadcasts these events:
          #
          # - :ok when everything is valid.
          # - :invalid if initiative is published, invalidated or illegal
          #
          # Returns nothing.
          def call
            return broadcast(:invalid) unless initiative.published? || initiative.invalidated? || initiative.illegal?

            @initiative = Decidim.traceability.perform_action!(
              :unpublish,
              initiative,
              current_user
            ) do
              initiative.unpublish!
              initiative
            end
            broadcast(:ok, initiative)
          end
        end
      end
    end
  end
end
