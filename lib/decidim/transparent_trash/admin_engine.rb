# frozen_string_literal: true

module Decidim
  module TransparentTrash
    # This is the engine that runs on the public interface of `TransparentTrash`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::TransparentTrash::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :transparent_trash do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "transparent_trash#index"
      end

      def load_seed
        nil
      end
    end
  end
end
