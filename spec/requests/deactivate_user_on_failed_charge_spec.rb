require 'spec_helper'

describe "deactivate user on failed charge" do
  let(:event_data) do
  {
    "id" => "evt_15R7CcIVhuhstyL6o0dkprmU",
    "created" => 1422733606,
    "livemode" => false,
    "type" => "charge.failed",
    "data" => {
      "object" => {
        "id" => "ch_15R7CcIVhuhstyL6nnJHp2uI",
        "object" => "charge",
        "created" => 1422733606,
        "livemode" => false,
        "paid" => false,
        "amount" => 999,
        "currency" => "eur",
        "refunded" => false,
        "captured" => false,
        "card" => {
          "id" => "card_15R7BQIVhuhstyL69j7c3lHX",
          "object" => "card",
          "last4" => "0341",
          "brand" => "Visa",
          "funding" => "credit",
          "exp_month" => 9,
          "exp_year" => 2025,
          "fingerprint" => "MzI3xc148smitNr5",
          "country" => "US",
          "name" => nil,
          "address_line1" => nil,
          "address_line2" => nil,
          "address_city" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_country" => nil,
          "cvc_check" => "pass",
          "address_line1_check" => nil,
          "address_zip_check" => nil,
          "dynamic_last4" => nil,
          "customer" => "cus_5SIEncmZZ1tVIp"
        },
        "balance_transaction" => nil,
        "failure_message" => "Your card was declined.",
        "failure_code" => "card_declined",
        "amount_refunded" => 0,
        "customer" => "cus_5SIEncmZZ1tVIp",
        "invoice" => nil,
        "description" => "payment to fail",
        "dispute" => nil,
        "metadata" => {},
        "statement_descriptor" => nil,
        "fraud_details" => {},
        "receipt_email" => nil,
        "receipt_number" => nil,
        "shipping" => nil,
        "refunds" => {
          "object" => "list",
          "total_count" => 0,
          "has_more" => false,
          "url" => "/v1/charges/ch_15R7CcIVhuhstyL6nnJHp2uI/refunds",
          "data" => []
        },
        "statement_description" => nil
      }
    },
    "object" => "event",
    "pending_webhooks" => 1,
    "request" => "iar_5cLuFYcDkInWBc",
    "api_version" => "2014-08-20"
  }
  end

  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do 
    amanda = Fabricate(:user, customer_token: "cus_5SIEncmZZ1tVIp" )
    post "/stripe_events", event_data 
    expect(amanda.reload).not_to be_active
  end
end