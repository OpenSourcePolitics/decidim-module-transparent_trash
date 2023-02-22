# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module TransparentTrash
    # This is the engine that runs on the public interface of transparent_trash.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::TransparentTrash

      routes do
        # Add engine routes here
        # resources :transparent_trash
        # root to: "transparent_trash#index"
      end

      initializer "TransparentTrash.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      config.to_prepare do
        # Commands
        Decidim::Initiatives::Admin::UnpublishInitiative.include Decidim::TransparentTrash::Extends::UnpublishInitiative
        # Permissions
        Decidim::Initiatives::Permissions.include Decidim::TransparentTrash::Extends::InitiativesPermissions
        Decidim::Initiatives::Admin::Permissions.include Decidim::TransparentTrash::Extends::InitiativesAdminPermissions
        # Controllers
        Decidim::Initiatives::InitiativesController.include Decidim::TransparentTrash::Extends::InitiativesController
        Decidim::Initiatives::Admin::InitiativesController.include Decidim::TransparentTrash::Extends::InitiativesAdminController
        # Models
        Decidim::Comments::Seed.include Decidim::TransparentTrash::Extends::CommentsSeed
        # Presenters
        Decidim::Initiatives::AdminLog::InitiativePresenter.include Decidim::TransparentTrash::Extends::InitiativePresenter
      end
    end
  end
end
