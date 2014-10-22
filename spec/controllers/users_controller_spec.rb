require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid info and valid card input" do
      let(:charge) {double(:charge, successful?: true)}
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to sign_in_path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        amanda = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: amanda, recipient_email: 'joe@example.com')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Doe"}, invitation_token: invitation.token
        joe = User.where(email: 'joe@example.com').first
        expect(joe.follows?(amanda)).to be_true
      end

      it "makes the inviter follow the user" do
        amanda = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: amanda, recipient_email: 'joe@example.com')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Doe"}, invitation_token: invitation.token
        joe = User.where(email: 'joe@example.com').first
        expect(amanda.follows?(joe)).to be_true
      end

      it "expires the invitation upon acceptance" do
        amanda = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: amanda, recipient_email: 'joe@example.com')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Doe"}, invitation_token: invitation.token
        joe = User.where(email: 'joe@example.com').first
        expect(Invitation.first.token).to be_nil
      end
    end
    context "with valid personal input and declined card" do 
      it "does not create a new user" do 
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(User.count).to eq(0)
      end 
      it "renders the new template" do 
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(response).to render_template :new
      end
      it "sets an error message" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241' 
        expect(flash[:danger]).to be_present
      end
    end

    context "with invalid personal info" do
      it "does not create the user" do
        post :create, user: {email: "mat@fat.com"}
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        post :create, user: {email: "mat@fat.com"}
        expect(response).to render_template :new
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: {email: "mat@fat.com"}
      end

      it "does not send out email with invalid inputs" do
        post :create, user: { email: "amanda@example.com"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "sending emails" do
      let(:charge) {double(:charge, successful?: true)}
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "amanda@example.com", password: "password", full_name: "Amanda Sander"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['amanda@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: "amanda@example.com", password: "password", full_name: "Amanda Sander"}
        expect(ActionMailer::Base.deliveries.last.body).to include('Amanda Sander')
      end
    end
  end   

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3}
    end

    it "sets @user" do
      set_current_user
      amanda = Fabricate(:user)
      get :show, id: amanda.id
      expect(assigns(:user)).to eq(amanda)
    end
  end

  describe "GET new with invitation token" do

    it "renders the new view template" do  
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: '1234567'
      expect(response).to redirect_to expired_token_path 
    end

  end

end