# frozen_string_literal: true

FactoryBot.define do

  factory :endpoint do
    name { 'test' }
    client_tag { 'github' }
    url_path { '/test/:things' }
    params { {things: {optional: true, type: 'String'}} }
    request_method { 'post' }
    body_template { nil }

    after(:create) do |endpoint|
      endpoint.reload
    end
  end
end
