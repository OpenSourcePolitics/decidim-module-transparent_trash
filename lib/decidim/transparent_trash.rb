# frozen_string_literal: true

require "decidim/transparent_trash/admin"
require "decidim/transparent_trash/engine"
require "decidim/transparent_trash/admin_engine"
require "decidim/transparent_trash/component"
# Extends
require "decidim/transparent_trash/extends/unpublish_initiative"

module Decidim
  # This namespace holds the logic of the `TransparentTrash` component. This component
  # allows users to create transparent_trash in a participatory space.
  module TransparentTrash
  end
end
