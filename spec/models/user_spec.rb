require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  def valid_attributes(new_attributes = {})
    attributes = {
      first_name: 'Ainkaran',
      last_name: 'Pathmanathan',
      email: 'ap@gmail.com',
      password: '123456'
    }
    attributes.merge(new_attributes)
  end

  describe "Validations" do
    it "requires a first_name" do
      user = User.new(valid_attributes(first_name: nil))
      expect(user).to be_invalid
    end

    it "requires a last_name" do
      user = User.new(valid_attributes(last_name: nil))
      expect(user).to be_invalid
    end

    # require an email
    it "requires a email" do
      user = User.new(valid_attributes(email: nil))
      expect(user).to be_invalid
    end

    # email must be unique
    it "requires a unique email" do
      User.create(valid_attributes)
      user = User.new(valid_attributes)
      expect(user).to be_invalid
      # user.save
      # expect(user.errors.messages).to have_key(:email)
    end

    it "requires a valid email" do
      user = User.new(valid_attributes(email: 'blahblahblah'))
      expect(user).to be_invalid
    end

    describe "full_name method" do
      it "returns the first name and last name concatenated and titleized" do
        full_name = "#{valid_attributes[:first_name]} #{valid_attributes[:last_name]}"
        user = User.new(valid_attributes({first_name: 'ainkaran', last_name: 'pathmanathan'}))
        expect(user.full_name).to eq(full_name)
      end
    end
  end

end
