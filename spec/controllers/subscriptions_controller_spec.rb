require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
    before do
        request.headers['Content-Type'] = 'application/json'
    end

    describe "POST #create" do
        before :each do
            Subscription.delete_all
            expect(Subscription.count).to be(0)
        end

        context "with valid parameters" do
            let(:valid_attributes) { { name: "John Wick", email: "johnwick@example.com" } }

            before :each do
                post :create, params: { subscription: valid_attributes }
            end

            it "creates a new Subscription" do
                expect(Subscription.count).to be(1)
            end

            it "renders a JSON response with the new subscription" do
                expect(response).to have_http_status(:created)
                expect(response.code).to eq('201')
                expect(response.content_type).to include('application/json')
            end            
        end

        context "with invalid parameters" do
            context "with duplicate email" do
                let(:duplicate_email_attributes) { { name: "John Wick II", email: "johnwick@example.com" } }

                before do
                    FactoryBot.create(:subscription)
                    post :create, params: { subscription: duplicate_email_attributes }
                end

                it "does not create a duplicate email Subscription" do
                    expect(Subscription.count).to be(1)
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Email has already been taken\"]")
                end
            end

            context "with invalid email" do
                let(:invalid_email_attributes) { { name: "John Wick", email: "johnwick@ex@mple.com" } }

                before do
                    post :create, params: { subscription: invalid_email_attributes }
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Email is invalid\"]")
                end

                it "does not create a new Subscription" do
                    expect(Subscription.count).to be(0)
                end
            end
    
            context "with empty name and email" do
                let(:invalid_attributes) { { name: "", email: "" } }

                before do
                    post :create, params: { subscription: invalid_attributes }
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Name can't be blank\",\"Email can't be blank\",\"Email is invalid\"]")
                end

                it "does not create a new Subscription" do
                    expect(Subscription.count).to be(0)
                end
            end
    
            context "with empty name and invalid email" do
                let(:invalid_attributes) { { name: "", email: "johnwick@ex@mple.com" } }

                before do
                    post :create, params: { subscription: invalid_attributes }
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Name can't be blank\",\"Email is invalid\"]")
                end

                it "does not create a new Subscription" do
                    expect(Subscription.count).to be(0)
                end
            end
        end
    end

    
    describe "PUT #update" do
        context "with valid parameters" do
            before :each do
                Subscription.delete_all
                @subscription = FactoryBot.create(:subscription)
            end

            let(:new_attributes) { { name: "John Wick II", email: "johnwick@example.com" } }

            before :each do
                put :update, params: { id: @subscription.id, subscription: new_attributes }
            end

            it "renders a JSON response with the Subscription" do
                expect(response).to have_http_status(:ok)
                expect(response.code).to eq('200')
                expect(response.content_type).to include('application/json')
            end

            it "updates the same Subscription" do
                expect(Subscription.count).to be(1)
            end     
        end

        context "with invalid parameters" do
            before do
                Subscription.delete_all
                @subscription = FactoryBot.create(:subscription)
            end

            context "with duplicate email" do
                let(:valid_attributes) { { name: "John Wick II", email: "johnwick2@example.com" } }
                let(:duplicate_email_attributes) { { name: "John Wick", email: "johnwick2@example.com" } }

                before do
                    post :create, params: { subscription: valid_attributes }
                    put :update, params: { id: @subscription.id, subscription: duplicate_email_attributes }
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Email has already been taken\"]")
                end
            end

            context "with invalid email" do
                let(:invalid_email_attributes) { { name: "John Wick", email: "johnwick@ex@mple.com" } }

                before do
                    put :update, params: { id: @subscription.id, subscription: invalid_email_attributes }
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Email is invalid\"]")
                end
            end
    
            context "with empty name and email" do
                let(:invalid_attributes) { { name: "", email: "" } }

                before do
                    put :update, params: { id: @subscription.id, subscription: invalid_attributes }
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Name can't be blank\",\"Email can't be blank\",\"Email is invalid\"]")
                end
            end
    
            context "with empty name and invalid email" do
                let(:invalid_attributes) { { name: "", email: "johnwick@ex@mple.com" } }

                before do
                    put :update, params: { id: @subscription.id, subscription: invalid_attributes }
                end

                it "returns Unprocessable entity and error message" do
                    expect(response.code).to eq('422')
                    expect(response.body).to eq("[\"Name can't be blank\",\"Email is invalid\"]")
                end
            end
        end
    end
end
