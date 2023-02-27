# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module TransparentTrash
    module Extends
      # module: decidim-initiatives
      # path: decidim-initiatives/app/presenters/decidim/initiatives/admin_log/initiative_presenter.rb
      module InitiativePresenter
        extend ActiveSupport::Concern

        included do
          private

          def action_string
            case action
            when "publish", "unpublish", "update", "send_to_technical_validation", "invalidate", "illegal"
              "decidim.initiatives.admin_log.initiative.#{action}"
            else
              super
            end
          end

          def diff_actions
            super + %w(publish unpublish send_to_technical_validation invalidate illegal)
          end
        end
      end
    end
  end
end
