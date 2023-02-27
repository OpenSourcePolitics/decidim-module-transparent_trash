# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module TransparentTrash
    module Extends
      # module: decidim-initiatives
      # path: decidim-initiatives/app/controllers/decidim/initiatives/initiatives_controller.rb
      module InitiativesController
        extend ActiveSupport::Concern

        included do
          # GET /initiatives
          # or
          # GET /initiatives?visibility=transparent
          #
          # Returns original index of initiatives without illegal and invalidated initiatives
          # When param visibility is present
          # Returns list of illegal and invalidated initiatives only
          def index
            enforce_permission_to :list, :initiative

            return index_initiatives unless transparent_initiatives?

            params[:filter] ||= {}
            params[:filter][:with_any_state] = search_transparent_initiatives_state
            @search = search_with(filter_params.merge(with_any_state: search_transparent_initiatives_state))
            render template: "decidim/transparent_trash/initiatives/index"
          end

          private

          def search_collection
            initiatives = Initiative
                          .includes(scoped_type: [:scope])
                          .joins("JOIN decidim_users ON decidim_users.id = decidim_initiatives.decidim_author_id")
                          .where(organization: current_organization)

            transparent_initiatives? ? initiatives.transparent : initiatives.not_transparent
          end

          # Returns index of initiatives
          def index_initiatives
            return unless search.result.blank? && params.dig("filter", "with_any_state") != %w(closed)

            @closed_initiatives ||= search_with(filter_params.merge(with_any_state: %w(closed)))

            if @closed_initiatives.result.present?
              params[:filter] ||= {}
              params[:filter][:with_any_state] = %w(closed)
              @forced_closed_initiatives = true

              @search = @closed_initiatives
            end
          end

          # returns any_state as open or any_transparent_states
          def with_any_state
            return search_transparent_initiatives_state if transparent_initiatives?

            search_initiatives_state
          end

          def search_initiatives_state
            %w(open)
          end

          def search_transparent_initiatives_state
            Decidim::Initiative::TRANSPARENT_STATES
          end

          # Check if request concern transparent trash or initiatives index
          def transparent_initiatives?
            return true if params["visibility"] == "transparent"
            return true if params.dig("filter", "visibility") == "transparent"

            false
          end
        end
      end
    end
  end
end
