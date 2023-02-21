# frozen_string_literal: true

require "decidim/transparent_trash/test/factories"
require "decidim/initiatives/test/factories"

FactoryBot.modify do
  factory :initiative, class: "Decidim::Initiative" do
    title { generate_localized_title }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    organization
    author { create(:user, :confirmed, organization: organization) }
    published_at { Time.current }
    state { "published" }
    signature_type { "online" }
    signature_start_date { Date.current - 1.day }
    signature_end_date { Date.current + 120.days }

    scoped_type do
      create(:initiatives_type_scope,
             type: create(:initiatives_type, organization: organization, signature_type: signature_type))
    end

    after(:create) do |initiative|
      if initiative.author.is_a?(Decidim::User) && Decidim::Authorization.where(user: initiative.author).where.not(granted_at: nil).none?
        create(:authorization, user: initiative.author, granted_at: Time.now.utc)
      end
      create_list(:initiatives_committee_member, 3, initiative: initiative)
    end

    trait :created do
      state { "created" }
      published_at { nil }
      signature_start_date { nil }
      signature_end_date { nil }
    end

    trait :validating do
      state { "validating" }
      published_at { nil }
      signature_start_date { nil }
      signature_end_date { nil }
    end

    trait :published do
      state { "published" }
    end

    trait :invalidated do
      state { "invalidated" }
    end

    trait :illegal do
      state { "illegal" }
    end

    trait :unpublished do
      published_at { nil }
    end

    trait :accepted do
      state { "accepted" }
    end

    trait :discarded do
      state { "discarded" }
    end

    trait :rejected do
      state { "rejected" }
    end

    trait :online do
      signature_type { "online" }
    end

    trait :offline do
      signature_type { "offline" }
    end

    trait :acceptable do
      signature_start_date { Date.current - 3.months }
      signature_end_date { Date.current - 2.months }
      signature_type { "online" }

      after(:build) do |initiative|
        initiative.online_votes[initiative.scope.id.to_s] = initiative.supports_required + 1
        initiative.online_votes["total"] = initiative.supports_required + 1
      end
    end

    trait :rejectable do
      signature_start_date { Date.current - 3.months }
      signature_end_date { Date.current - 2.months }
      signature_type { "online" }

      after(:build) do |initiative|
        initiative.online_votes[initiative.scope.id.to_s] = 0
        initiative.online_votes["total"] = 0
      end
    end

    trait :with_user_extra_fields_collection do
      scoped_type do
        create(:initiatives_type_scope,
               type: create(:initiatives_type, :with_user_extra_fields_collection, organization: organization))
      end
    end

    trait :with_area do
      area { create(:area, organization: organization) }
    end

    trait :with_documents do
      transient do
        documents_number { 2 }
      end

      after :create do |initiative, evaluator|
        evaluator.documents_number.times do
          initiative.attachments << create(
            :attachment,
            :with_pdf,
            attached_to: initiative
          )
        end
      end
    end

    trait :with_photos do
      transient do
        photos_number { 2 }
      end

      after :create do |initiative, evaluator|
        evaluator.photos_number.times do
          initiative.attachments << create(
            :attachment,
            :with_image,
            attached_to: initiative
          )
        end
      end
    end
  end
end
