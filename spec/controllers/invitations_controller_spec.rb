require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets @invitation to a new invitation" do
    	set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    after { ActionMailer::Base.deliveries.clear }

    context "with valid input" do
      
      it "creates an invitation" do
        set_current_user
        post :create, invitation: {recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(Invitation.count).to eq(1)
      end

      it "redirects to the invitation/new page" do
        set_current_user
        post :create, invitation: {recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(response).to redirect_to new_invitation_path
      end

      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: {recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sets a flash success message" do
        set_current_user
        post :create, invitation: {recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid input" do
      it "does not create the invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(Invitation.count).to eq(0)
      end

      it "renders the new template" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(response).to render_template :new
      end

      it "does not send out an email" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end   
      it "sets an error message" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(flash[:danger]).to be_present
      end

      it "sets the invitation variable" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com", message: "Hey check this out"}
        expect(assigns(:invitation)).to be_present
      end

    end
  end
end