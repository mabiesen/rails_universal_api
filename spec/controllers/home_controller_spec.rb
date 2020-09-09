# frozen_string_literal: true

require 'rails_helper'

describe HomeController, type: :controller do
  let(:github_endpoint ) { FactoryBot.create(:endpoint) }

  before(:each) do
    github_endpoint.save!
  end

  describe '#index' do
    it 'should render html' do
      get :index
      expect(response.status).to eq(200)
      expect(response.content_type).to eq("text/html; charset=utf-8")
    end
  end

  describe '#endpoint_page' do
    context 'when supplied an endpoint_id' do
      it 'should render html' do
        github_endpoint.save!
        id = github_endpoint.reload.id
        get :endpoint_page, params: {endpoint_id: id}
        expect(response.status).to eq(200)
        expect(response.content_type).to eq("text/html; charset=utf-8")
      end
    end
  end

end
