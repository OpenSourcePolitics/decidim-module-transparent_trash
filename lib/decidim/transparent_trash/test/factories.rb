# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :transparent_trash_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :transparent_trash).i18n_name }
    manifest_name :transparent_trash
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
