# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Initiatives
    module Admin
      describe InvalidateInitiative do
        subject { described_class.new(initiative, user) }

        let!(:initiative) { create :initiative, :validating }
        let!(:components) { create_list :component, 4, participatory_space: initiative  }
        let!(:user) { create :user, :admin, :confirmed, organization: initiative.organization }

        context "when the initiative is already published" do
          let(:initiative) { create :initiative, :published }

          it "broadcasts :invalid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          it "publishes the initiative as illegal" do
            expect { subject.call }.to change(initiative, :state).from("validating").to("invalidated")
          end

          it "unpublishes all related components" do
            expect(initiative.components.map(&:published?)).to eq([true]*4)
            subject.call
            initiative.reload
            expect(initiative.components.map(&:published?)).to eq([false]*4)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with(:invalidate, initiative, user)
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
          end
        end
      end
    end
  end
end
