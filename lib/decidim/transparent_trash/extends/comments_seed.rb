# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module TransparentTrash
    module Extends
      # module: decidim-comments
      # path: decidim-comments/app/models/decidim/comments/seed.rb
      module CommentsSeed
        extend ActiveSupport::Concern

        included do
          # Public: adds a random amount of comments for a given resource.
          #
          # resource - the resource to add the coments to.
          # returns nil if resource is Decidim::Initiative and initiative is invalidated or illegal
          #
          # Returns nothing.
          def self.comments_for(resource)
            return unless resource.accepts_new_comments?
            return if resource.is_a?(Decidim::Initiative) && (resource.invalidated? || resource.illegal?)

            Decidim::Comments::Comment.reset_column_information

            organization = resource.organization

            2.times do
              author = Decidim::User.where(organization: organization).all.sample
              user_group = [true, false].sample ? Decidim::UserGroups::ManageableUserGroups.for(author).verified.sample : nil

              params = {
                commentable: resource,
                root_commentable: resource,
                body: { en: ::Faker::Lorem.sentence(word_count: 50) },
                author: author,
                user_group: user_group
              }

              Decidim.traceability.create!(
                Decidim::Comments::Comment,
                author,
                params,
                visibility: "public-only"
              )
            end
          end
        end
      end
    end
  end
end
