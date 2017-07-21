require 'rails_helper'

RSpec.describe Review, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:product) { FactoryGirl.build(:product) }
  let(:user)    { FactoryGirl.build(:user) }

  def valid_attributes(new_attributes)
    attributes = {
      body:       Faker::Hacker.say_something_smart,
      rating:     rand(1..5),
      product_id: product.id,
      user_id:    user.id
    }
    attributes.merge(new_attributes)
  end

  describe "validations" do
    context 'rating' do
      it "requires a rating" do
        review = Review.new(valid_attributes({ rating: nil }))
        expect(review).to be_invalid
      end

      it "produces a validation error" do
        review = Review.new(valid_attributes({ rating: nil }))
        review.save
        expect(review.errors[:rating]).to include("can't be blank")
      end

      it "requires ratings to be between an integer" do
        review = Review.new(valid_attributes({ rating: 'Hey Buddy' }))
        expect(review).to be_invalid
      end

      it "requires ratings to be greater than 1" do
        review  = Review.new(valid_attributes({ rating: 0 }))
        expect(review).to be_invalid
      end

      it "requires ratings to be less than 5" do
        review  = Review.new(valid_attributes({ rating: 6 }))
        expect(review).to be_invalid
      end
    end
  end
end
