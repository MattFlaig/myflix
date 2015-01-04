require 'spec_helper'

describe "Create Payment on Successful Charge" do
  let(:event_data) do 
  {
    "id"=> "evt_15HJgzIVhuhstyL65O3EqHOW",
    "created"=> 1420398337,
    "livemode"=> false,
    "type"=> "charge.succeeded",
    "data"=> {
      "object"=> {
        "id"=> "ch_15HJgzIVhuhstyL6tm937CIR",
        "object"=> "charge",
        "created"=> 1420398337,
        "livemode"=> false,
        "paid"=> true,
        "amount"=> 999,
        "currency"=> "eur",
        "refunded"=> false,
        "captured"=> true,
        "card"=> {
          "id"=> "card_15HJgxIVhuhstyL6sECb40tl",
          "object"=> "card",
          "last4"=> "4242",
          "brand"=> "Visa",
          "funding"=> "credit",
          "exp_month"=> 2,
          "exp_year"=> 2017,
          "fingerprint"=> "nSRoAStmUco3w3Ow",
          "country"=> "US",
          "name"=> nil,
          "address_line1"=> nil,
          "address_line2"=> nil,
          "address_city"=> nil,
          "address_state"=> nil,
          "address_zip"=> nil,
          "address_country"=> nil,
          "cvc_check"=> "pass",
          "address_line1_check"=> nil,
          "address_zip_check"=> nil,
          "dynamic_last4"=> nil,
          "customer"=> "cus_5SE9RnL6Qlj9BY"
        },
        "balance_transaction"=> "txn_15HJgzIVhuhstyL6RlfmSQqw",
        "failure_message"=> nil,
        "failure_code"=> nil,
        "amount_refunded"=> 0,
        "customer"=> "cus_5SE9RnL6Qlj9BY",
        "invoice"=> "in_15HJgyIVhuhstyL6TOSUsYwq",
        "description"=> nil,
        "dispute"=> nil,
        "metadata"=> {},
        "statement_descriptor"=> nil,
        "fraud_details"=> {},
        "receipt_email"=> nil,
        "receipt_number"=> nil,
        "shipping"=> nil,
        "refunds"=> {
          "object"=> "list",
          "total_count"=> 0,
          "has_more"=> false,
          "url"=> "/v1/charges/ch_15HJgzIVhuhstyL6tm937CIR/refunds",
          "data"=> []
        },
        "statement_description"=> nil
      }
    },
    "object"=> "event",
    "pending_webhooks"=> 1,
    "request"=> "iar_5SE9xeCG3UeFMQ",
    "api_version"=> "2014-08-20"
  }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do 
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do 
    amanda = Fabricate(:user, customer_token: "cus_5SE9RnL6Qlj9BY")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(amanda)
  end

  it "creates the payment with the amount", :vcr do 
    amanda = Fabricate(:user, customer_token: "cus_5SE9RnL6Qlj9BY")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do 
    amanda = Fabricate(:user, customer_token: "cus_5SE9RnL6Qlj9BY")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_15HJgzIVhuhstyL6tm937CIR")
  end

end