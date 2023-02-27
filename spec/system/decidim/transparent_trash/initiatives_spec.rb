# frozen_string_literal: true

require "spec_helper"

describe "Initiatives", type: :system do
  let(:route) { decidim_initiatives.initiatives_path(visibility: :transparent) }
  let(:organization) { create(:organization) }
  let!(:initiative) { create(:initiative, organization: organization) }
  let!(:invalidated_initiative) { create(:initiative, :invalidated, organization: organization) }
  let!(:illegal_initiative) { create(:initiative, :illegal, organization: organization) }

  before do
    switch_to_host(organization.host)
    visit route
  end

  it "only lists invalidated and illegal initiatives" do
    within "#initiatives-count" do
      expect(page).to have_content("2")
    end

    within "#initiatives" do
      expect(page).not_to have_content(translated(initiative.title, locale: :en))
      expect(page).to have_content(translated(invalidated_initiative.title, locale: :en))
    end
  end

  context "when an initiative is illegal" do
    it "does not display content" do
      within "#initiatives" do
        expect(page).to have_content(translated(invalidated_initiative.title, locale: :en))
        expect(page).not_to have_content(translated(illegal_initiative.title, locale: :en))
        expect(page).to have_content("Title content moderated")
        expect(page).to have_content("Description content moderated")
      end
    end
  end

  it "does not implement filters" do
    expect(page).not_to have_css(".with_any_state_check_boxes_tree_filter")
    expect(page).not_to have_css(".with_any_scope_check_boxes_tree_filter")
    expect(page).not_to have_css(".with_any_type_check_boxes_tree_filter")
    expect(page).not_to have_css(".with_any_area_check_boxes_tree_filter")
  end

  it "implements search bar" do
    expect(page).to have_css(".filters__search")
  end

  it "does not display transparent trash link" do
    expect(page).not_to have_link("Access transparent trash")
  end

  it "display go back link" do
    expect(page).to have_link("Go back to initiatives list")
  end
end
