# frozen_string_literal: true

require "spec_helper"

module Decidim::Initiatives
  describe InitiativeMCell, type: :cell do
    controller Decidim::Initiatives::InitiativesController

    subject { cell_html }

    let(:my_cell) { cell("decidim/initiatives/initiative_m", initiative, context: { show_space: show_space }) }
    let(:cell_html) { my_cell.call }
    let(:state) { :published }
    let(:organization) { create(:organization) }
    let!(:initiative) { create(:initiative, organization: organization, hashtag: "my_hashtag", state: state) }
    let(:user) { create :user, organization: initiative.organization }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(subject).to have_css(".card--initiative")
      end

      it "renders the initiative content" do
        expect(subject.to_s).to include(translated(initiative.title))
        expect(subject.to_s).to include(translated(initiative.description))
      end

      it "renders follow button" do
        expect(subject).to have_css(".follow-button")
      end

      shared_examples_for "card shows signatures" do
        it "shows signatures" do
          expect(subject).to have_css(".progress__bar__number")
          expect(subject).to have_css(".progress__bar__text")
          expect(subject.to_s).to include("signatures")
        end
      end

      shared_examples_for "card does not show signatures" do
        it "does not show signatures" do
          expect(subject).not_to have_css(".progress__bar__number")
          expect(subject).not_to have_css(".progress__bar__text")
          expect(subject.to_s).not_to include("signatures")
        end
      end

      it "renders the hashtag" do
        expect(subject).to have_content("#my_hashtag")
      end

      it_behaves_like "card shows signatures"

      context "when initiative state is rejected" do
        let(:state) { :rejected }

        it_behaves_like "card shows signatures"
      end

      context "when initiative state is accepted" do
        let(:state) { :accepted }

        it_behaves_like "card shows signatures"
      end

      context "when initiative state is created" do
        let(:state) { :created }

        it_behaves_like "card does not show signatures"
      end

      context "when initiative state is validating" do
        let(:state) { :validating }

        it_behaves_like "card does not show signatures"
      end

      context "when initiative state is discarded" do
        let(:state) { :discarded }

        it_behaves_like "card does not show signatures"
      end

      context "when initiative state is invalidated" do
        let(:state) { :invalidated }

        it_behaves_like "card does not show signatures"

        it "does not render comments" do
          expect(subject).not_to have_css(".comments_count_status")
          expect(subject).not_to have_content("0 comments")
        end

        it "does not render follow button" do
          expect(subject).not_to have_css(".follow-button")
        end
      end

      context "when initiative state is illegal" do
        let(:state) { :illegal }

        it_behaves_like "card does not show signatures"

        it "does not render comments" do
          expect(subject).not_to have_css(".comments_count_status")
          expect(subject).not_to have_content("0 comments")
        end

        it "does not render the initiative content" do
          expect(subject.to_s).to include("Title content moderated")
          expect(subject.to_s).to include("Description content moderated")
          expect(subject.to_s).not_to include(translated(initiative.title))
          expect(subject.to_s).not_to include(translated(initiative.description))
        end
      end

      context "when comments are disabled on initiative type" do
        let!(:initiative) { create(:initiative, hashtag: "my_hashtag", state: state) }

        before do
          allow(initiative.type).to receive(:comments_enabled?).and_return(false)
        end

        it "does not render comments" do
          expect(subject).not_to have_css(".comments_count_status")
          expect(subject).not_to have_content("0 comments")
        end
      end
    end
  end
end
