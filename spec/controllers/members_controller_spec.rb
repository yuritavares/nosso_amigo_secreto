require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
    @member2 = create(:member)
  end

  describe 'POST #create' do
    before(:each) do
      @member_attributes = attributes_for(:member)
      @campaign = create(:campaign, title: 'Right one')
      post :create, params: {member: @member_attributes, campaign: @campaign}
    end

    it 'Return http success' do
      expect(response).to have_http_status(:success)
      expect(Member.last.name).to eq(@member_attributes[:name])
    end

    it 'Member is in right campaign' do
      expect(Member.campaign.title).to eq(@campaign.title)
    end

    it 'Returns 422 when members is already on the campaign' do
      @member = Member.last
      put :update, params: {id: @member.id, campaign: @campaign }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    context 'When use not logged' do
      before(:each) do
        sign_out @current_user
        put :update, params: {id: @member2.id, campaign: @campaign}
      end

      it 'Return  status 403' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #destroy' do
    before do
      delete :destroy, params: {id: @member.id}
    end

    it 'Returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'When the member is already deleted' do
      delete :destroy, params: {id: @member.id}

      expect(response).to have_http_status(404)
    end

  end

  describe 'GET #update' do
    it 'returns http success' do
      get :update
      expect(response).to have_http_status(:success)
    end
  end
end
