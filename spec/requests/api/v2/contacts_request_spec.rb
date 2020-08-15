# to run: bundle exec rspec spec/requests/api/v2/contacts_request_spec.rb

require 'rails_helper'

RSpec.describe "Api::V2::Contacts", type: :request do
  #
  # GET /api/v2/contacts
  #
  describe 'GET /api/v2/contacts' do
    let!(:user) { create(:user) }
    let!(:contacts) do 
      create_list(:contact_with_address, 5, user: user)
    end

    context 'with valid user and token' do

      before do
        get "/api/v2/contacts/",
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns contacts as json' do
        #expect(json).not_to be_empty
        expect(response.body).to match(/addresses/)
      end

    end

  end

  #
  # GET /api/v2/contacts/:id
  #
  describe 'GET /api/v2/contacts/:id' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact_with_address, user: user) }

    context 'when the contact exists' do

      before do
        get "/api/v2/contacts/#{contact.id}",
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }

      end

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct contact' do
        expect(contact).to have_attributes(json.except('created_at', 'updated_at', 'addresses'))#TODO: ajustar
      end

    end

    context 'when the contact does not exist' do

      before do
        get "/api/v2/contacts/0",
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
  # POST /api/v2/contacts
  #
  describe 'POST /api/v2/contacts' do
    let!(:user) { create(:user) }
    let!(:address) { attributes_for(:address, contact: nil) }
    let!(:contact) { attributes_for(:contact, user: nil) }
    
    context 'with valid params' do

      before do
        address.delete(:contact)
        contact.delete(:user)
        contact_attributes = contact.clone
        contact_attributes[:addresses] = address

        post "/api/v2/contacts/",
          params: { 'contact': contact_attributes },
          headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
          }
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'creates the contact' do
        expect(Contact.last).to have_attributes(contact)
      end

      it 'creates the address' do
        expect(Contact.last.addresses.last).to have_attributes(address)
      end
    end

    context 'with invalid params' do

      let!(:contact_attributes) { attributes_for(:contact, name: nil) }

      before do

        post "/api/v2/contacts/",
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
  # PUT /api/v2/contacts/:id
  #
  describe 'PUT /api/v2/contacts/:id' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact_with_address, user: user) }
    let!(:contact_attributes) { attributes_for(:contact, user: user) }
    let!(:address) { attributes_for(:address, contact: nil)}
    let!(:contact_with_address_attributes) { Hash.new }
        
    context 'when the contact exists' do

      before do
        address.delete(:contact)
        contact_attributes.delete(:user)
        contact_with_address_attributes = contact_attributes.clone
        contact_with_address_attributes[:addresses] = address

        put "/api/v2/contacts/#{contact.id}",
          params: { 'contact': contact_with_address_attributes },
          headers: {
            'X-User-Email': user.email,
            'X-User-Token': user.authentication_token
          }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the contact' do
        expect(contact.reload).to have_attributes(contact_attributes)
      end

      it 'updates the contact address' do
        expect(contact.addresses.last).to have_attributes(address)
      end

      it 'returns the updated contact' do
        expect(json).to have_attributes(contact_with_address_attributes)
      end

    end

    context 'when the contact does not exist' do

      before do
        put "/api/v2/contacts/0",
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
  # DELETE /api/v2/contacts/:id
  #
  describe 'DELETE /api/v2/contacts/:id' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact_with_address, user: user) }
    let!(:address) { contact.addresses.last }

    context 'when the contact exists' do

      before do
        delete "/api/v2/contacts/#{contact.id}",
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

      it 'destroy the record address' do
        expect { address.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the contact does not exist' do

      before do
        delete "/api/v2/contacts/0",
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
