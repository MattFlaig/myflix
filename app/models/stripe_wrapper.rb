module StripeWrapper
  class Charge
  	def self.create(options={})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: 'eur',
        card: options[:card],
        description: options [:description]
      	)
  	end
  end
end