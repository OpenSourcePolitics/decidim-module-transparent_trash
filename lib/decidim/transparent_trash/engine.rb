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

      initializer "decidim.transparent_trash.extends" do
        Decidim::Initiatives::Admin::UnpublishInitiative.include Decidim::TransparentTrash::Extends::UnpublishInitiative
      end
    end
  end
end
