# to run: bundle exec rspec spec/requests/api/v1/contacts_request_spec.rb

require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  #
  # GET /api/v1/contacts
  #
  describe 'GET /api/v1/contacts' do
    let!(:user) { create(:user) }
    let!(:contacts) do 
      create_list(:contact, 5, user: user)
    end

    context 'with valid user and token' do

      before do
        get "/api/v1/contacts/",
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns contacts as json' do
        expect(json).not_to be_empty
      end

    end

  end

  #
  # GET /api/v1/contacts/:id
  #
  describe 'GET /api/v1/contacts/:id' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact, user: user) }

    context 'when the contact exists' do

      before do
        get "/api/v1/contacts/#{contact.id}",
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }

      end

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct contact' do
        expect(contact).to have_attributes(json.except('created_at', 'updated_at'))
      end

    end

    context 'when the contact does not exist' do

      before do
        get "/api/v1/contacts/0",
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Contact with 'id'=0/)
      end
    end

  end

  # 
  # POST /api/v1/contacts
  #
  describe 'POST /api/v1/contacts' do
    let!(:user) { create(:user) }
    let!(:contact_attributes) { attributes_for(:contact, user: user) }

    context 'with valid params' do

      before do
        post "/api/v1/contacts/",
          params: { 'contact': contact_attributes },
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'creates the record' do
        expect(Contact.last).to have_attributes(contact_attributes)
      end
    end

    context 'with invalid params' do

      let!(:contact_attributes) { attributes_for(:contact, name: nil) }

      before do

        post "/api/v1/contacts/",
          params: { 'contact': contact_attributes },
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }

      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a name can\'t be blank message' do
        expect(response.body).to match(/can't be blank/)
      end

    end
  end

  #
  # PUT /api/v1/contacts/:id
  #
  describe 'PUT /api/v1/contacts/:id' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact, user: user) }
    let!(:contact_attributes) { attributes_for(:contact, user: user) }
        
    context 'when the contact exists' do

      before do
        put "/api/v1/contacts/#{contact.id}",
          params: { 'contact': contact_attributes },
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the record' do
        expect(contact.reload).to have_attributes(contact_attributes)
      end

      it 'returns the updated contact' do
        expect(contact.reload).to have_attributes(json.except('created_at', 'updated_at'))
      end

    end

    context 'when the contact does not exist' do

      before do
        put "/api/v1/contacts/0",
          params: { 'contact': contact_attributes },
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Contact with 'id'=0/)
      end
    end
  end

  #
  # DELETE /api/v1/contacts/:id
  #
  describe 'DELETE /api/v1/contacts/:id' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact, user: user) }

    context 'when the contact exists' do

      before do
        delete "/api/v1/contacts/#{contact.id}",
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
      
      it 'destroy the record' do
        expect { contact.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the contact does not exist' do

      before do
        delete "/api/v1/contacts/0",
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Contact with 'id'=0/)
      end

    end

  end

end