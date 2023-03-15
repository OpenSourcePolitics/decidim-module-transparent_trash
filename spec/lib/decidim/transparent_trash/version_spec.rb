# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe TransparentTrash do
    subject { described_class }

    it "has version" do
      expect(subject.version).to eq("0.0.2")
    end

    it "has Decidim version" do
      expect(subject.decidim_version).to eq("0.27.1")
    end
  end
end
