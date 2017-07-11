require 'rails_helper'

# To run all tests in your application:
# `rspec`

# To run tests of a specific file:
# `rspec path/to/file` (e.g. `rspec spec/models/product_spec.rb`)

# To a specific test:
# `rspec path/to/file:line_number_of_it` (e.g. `rspec spec/models/product_spec.rb:15`)

RSpec.describe Product, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

=begin
  Test drive the following:
  Product title must be present
  Product title is unique
  Product title gets capitalized after getting saved to the database
  Product description must be present
  Product price must be present
  Product price is more than 0
=end

  def valid_attributes(new_attributes)
    # attributes ||= Product.new title: 'Apple', price: 10, sale_price: 9, description: 'nice apple'
    # @product =  @product || Product.new title...
    attributes = {
      title: 'Apple',
      price: '10',
      description: 'nice apple'
    }
    attributes.merge(new_attributes)
  end

  describe 'validations' do
    # EXERCISE: check that first_name exists and that last_name exists
    # describe 'title' do
    context 'title' do
      it 'require a title' do
        # p = valid_product
        # p.title = nil
        p = Product.new(valid_attributes({title: nil}))
        p.valid?
        expect(p).to be_invalid
      end

      it 'requires unique titles' do
        p = Product.new(valid_attributes({title: 'Hey Buddy'}))
        p1 = Product.new(valid_attributes({title: 'Hey Buddy'}))
        p.save
        expect(p1).to be_invalid(:title)
      end

      it 'capitalizes the title after getting saved' do
        p = Product.new(valid_attributes({title: 'hey buddy'}))
        p.save
        expect(p.title).to eq('Hey buddy')
      end
    end
  end

  describe 'validate_search' do
    context 'title and description' do
      it 'found a product' do
        # GIVEN
        p1 = Product.new(valid_attributes({title: 'Acar', description: 'sweet a'}))
        p2 = Product.new(valid_attributes({title: 'Apple', description: 'sweet car'}))
        p1.save
        p2.save

        # WHEN
        pSearch = Product.search('apple')
        puts pSearch.inspect

        # THEN
        # expect(pSearch[0].title).to eq('Apple')
        expect(pSearch[0]).to eq(p2)
      end
    end
  end



end
