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

      initializer "decidim_transparent_trash.admin_mount_routes" do
        Decidim::Initiatives::AdminEngine.routes do
          resources :initiatives, only: [:index, :edit, :update], param: :slug do
            member do
              delete :invalidate
              delete :illegal
            end
          end
        end
      end

      def load_seed
        nil
      end
    end
  end
end
