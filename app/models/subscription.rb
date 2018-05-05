# == Schema Information
#
# Table name: subscriptions
#
#  id            :integer          not null, primary key
#  stripe_id     :string(255)
#  plan_id       :integer
#  last_four     :string(255)
#  coupon_id     :integer
#  card_type     :string(255)
#  current_price :float
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  device_id     :integer
#  canceled_at   :datetime
#

class Subscription < ActiveRecord::Base
  attr_accessor :canceling

  include Koudoku::Subscription

  belongs_to :user
  belongs_to :device
  belongs_to :coupon

  has_many :billings

  after_create :create_billing_history

  # Overriding method of koudoku gem to add support for
  # multiple subscriptions per user. One subscription
  # per device...

  def canceled?
    !self.canceled_at.nil? &&
      self.canceled_at < Time.now
  end

  def current_period_end
    Time.at(stripe_subscription.current_period_end)
  end

  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(self.stripe_id)
  end

  def processing!

    if subscription_owner.id && !self.user_id
      self.user_id = subscription_owner.user_id
    end

    # if their package level has changed ..
    if changing_plans?

      prepare_for_plan_change

      # and a customer exists in stripe ..
      if self.user.stripe_id.present?

        # fetch the customer.

        # if a new plan has been selected

        if self.plan.present?
          customer = Stripe::Customer.retrieve(self.user.stripe_id)

          # Record the new plan pricing.
          self.current_price = self.plan.price

          prepare_for_downgrade if downgrading?
          prepare_for_upgrade if upgrading?

          subscription = if self.stripe_id
            sub = Stripe::Subscription.retrieve(self.stripe_id)
            sub.plan = self.plan.stripe_id

            if upgrading?
              sub.prorate = Koudoku.prorate

              if sub.trial_end
                sub.trial_end = sub.trial_end
                sub.prorate = false
              end

              sub.save
            else
              sub.prorate = false
              sub.trial_end = sub.current_period_end
              sub.save
            end
          else
            # Create a new subscription...
            sub = Stripe::Subscription.create(
              :customer => self.user.stripe_id,
              :plan => self.plan.stripe_id,
              :prorate => Koudoku.prorate,
              :trial_end => self.user.stripe_trial_end_at
            )

            if self.user.subscription_start_at.nil?
              self.user.subscription_start_at = Time.now
              self.user.save!
            end

            sub
          end

          self.canceled_at = nil
          self.stripe_id = subscription.id
        end

      # when customer DOES NOT exist in stripe ..
      else

        # if a new plan has been selected
        if self.plan.present?

          # Record the new plan pricing.
          self.current_price = self.plan.price

          prepare_for_new_subscription
          prepare_for_upgrade

          begin

            customer_attributes = {
              description: subscription_owner_description,
              email: subscription_owner_email,
              card: credit_card_token # obtained with Stripe.js
            }

            # If the class we're being included in supports coupons ..
            if respond_to? :coupon
              if coupon.present? and coupon.free_trial?
                customer_attributes[:trial_end] = coupon.free_trial_ends.to_i
              end
            end

            customer_attributes[:coupon] = @coupon_code if @coupon_code

            # create a customer at that package level.
            customer = Stripe::Customer.create(customer_attributes)
            subscription = Stripe::Subscription.create(
              :customer => customer.id,
              :plan => self.plan.stripe_id,
              :prorate => Koudoku.prorate,
              :trial_end => self.user.stripe_trial_end_at
            )
            self.stripe_id = subscription.id

            if self.user.subscription_start_at.nil?
              self.user.subscription_start_at = Time.now
              self.user.save!
            end

            finalize_new_customer!(customer.id, plan.price)

          rescue Stripe::CardError => card_error
            errors[:base] << card_error.message
            card_was_declined
            return false
          end

          # store the customer id.
          self.user.stripe_id = customer.id
          self.user.save

          finalize_new_subscription!
          finalize_upgrade!

        else

          # This should never happen.

          self.plan_id = nil

          # Remove any plan pricing.
          self.current_price = nil

        end

      end

      finalize_plan_change!

    # if they're updating their credit card details.
    elsif self.credit_card_token.present?

      prepare_for_card_update

      # fetch the customer.
      customer = Stripe::Customer.retrieve(self.user.stripe_id)
      customer.card = self.credit_card_token
      customer.save

      finalize_card_update!

    elsif self.canceling

      prepare_for_cancelation

      # cancel the subscription
      subscription = Stripe::Subscription.retrieve(self.stripe_id)
      subscription.delete(at_period_end: true)

      finalize_cancelation!
    end
  end


  def subscription_owner_description
    "#{self.user.email}-#{self.user.id}"
  end

  def subscription_owner_email
    self.user.email
  end

  # private

    def create_billing_history
      self.billings.create({
        :last_four => self.last_four,
        :card_type => self.card_type,
        :start_date => self.updated_at,
        :end_date => self.updated_at + 1.send(plan.interval),
        :price => plan.price
      })
    end

end
