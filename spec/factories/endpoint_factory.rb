# frozen_string_literal: true

FactoryBot.define do

  factory :endpoint do
    name { 'test' }
    url_path { '/v1/test/:things' }
    params { {things: {optional: true, type: 'String'}} }
    brand { 'US' }
    request_method { 'post' }
    body_template { nil }

    after(:create) do |endpoint|
      endpoint.reload
    end
  end
end
