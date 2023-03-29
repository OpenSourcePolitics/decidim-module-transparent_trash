# frozen_string_literal: true

module Decidim
  module Initiatives
    # Exposes Initiatives versions so users can see how an Initiative
    # has been updated through time.
    class VersionsController < Decidim::Initiatives::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout
      helper InitiativeHelper

      include NeedsInitiative
      include Decidim::ResourceVersionsConcern

      def index
        enforce_permission_to :see_versioning, :initiative, initiative: current_initiative if current_initiative.illegal?
      end

      def show
        enforce_permission_to :see_versioning, :initiative, initiative: current_initiative if current_initiative.illegal?

        raise ActionController::RoutingError, "Not found" unless current_version
      end

      def versioned_resource
        current_initiative
      end

      private

      def current_participatory_space_manifest
        @current_participatory_space_manifest ||= Decidim.find_participatory_space_manifest(:initiatives)
      end
    end
  end
end
