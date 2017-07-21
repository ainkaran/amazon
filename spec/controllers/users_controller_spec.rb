require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "new" do
    it "creates a new user instance variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "create" do
    context "with valid params" do
      def valid_request
        attributes = {
          first_name: 'Ainkaran',
          last_name: 'Pathmanathan',
          email: 'ap@gmail.com',
          password: '123456'
        }

        post :create, params: { user: attributes }
      end

      it "creates a user in the database" do
        expect { valid_request }.to change { User.count }.by(1)
      end

      it "sets a flash notice" do
        valid_request
        expect(flash[:notice]).to be
      end

      it "redirects to the root path of the app" do
        valid_request
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      def invalid_request
        attributes = {
          first_name: 'Jacky',
          last_name: 'Chui',
        }

        post :create, params: { user: attributes}
      end

      it "does not create a user in the database" do
        expect { invalid_request }.to_not change { User.count }
      end

      it "sets an alert flash message" do
        invalid_request
        expect(flash[:alert]).to be
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end
    end
  end
end
