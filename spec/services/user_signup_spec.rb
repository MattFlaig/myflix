require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
  	context "valid personal input and card" do 
  		let(:charge) {double(:charge, successful?: true)}
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        amanda = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: amanda, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Doe" )).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(joe.follows?(amanda)).to be_true
      end

      it "makes the inviter follow the user" do
        amanda = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: amanda, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Doe" )).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(amanda.follows?(joe)).to be_true
      end

      it "expires the invitation upon acceptance" do
        amanda = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: amanda, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Doe" )).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user" do
      	UserSignup.new(Fabricate.build(:user, email: "joe@example.com" )).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name" do
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", full_name: "Joe Doe" )).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Doe')
      end

  	end

  	context "with valid personal input and declined card" do 
      it "does not create a new user" do 
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up('1231241', nil)
        expect(User.count).to eq(0)
      end 
    end

    context "with invalid personal info" do
      it "does not create the user" do
      	UserSignup.new(User.new(email: "mat@fat.com")).sign_up('1231241', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(User.new(email: "mat@fat.com")).sign_up('1231241', nil)
      end

      it "does not send out email with invalid inputs" do
        UserSignup.new(User.new(email: "mat@fat.com")).sign_up('1231241', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

  end
end