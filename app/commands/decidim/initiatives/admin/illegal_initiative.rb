# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # A command with all the business logic that unpublishes an
      # existing initiative.
      class IllegalInitiative < Decidim::Command
        # Public: Initializes the command.
        #
        # initiative - Decidim::Initiative
        # current_user - the user performing the action
        def initialize(initiative, current_user)
          @initiative = initiative
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if initiative.published?

          @initiative = Decidim.traceability.perform_action!(
            :illegal,
            initiative,
            current_user
          ) do
            initiative.components.each(&:unpublish!) if initiative.components.any?
            initiative.illegal!
            initiative
          end
          broadcast(:ok, initiative)
        end

        private

        attr_reader :initiative, :current_user
      end
    end
  end
end
