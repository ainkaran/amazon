require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user)      {FactoryGirl.create(:user)}
  let(:category)  {FactoryGirl.create(:category)}
  let(:product)   {FactoryGirl.create(:product, category: category)}
  let(:product_1) {FactoryGirl.create(:product, category: category, user: user)}

  describe "index" do
    it "assigns an instance variable for all the products" do
      product
      product_1
      get :index
      expect(assigns(:products)).to eq([product_1, product])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "show" do
    before { get :show, params: { id: product.id } }

    it "sets and instance variable with the product whose id is passed in" do
      expect(assigns(:product)).to eq(product)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "destroy" do
    context "with user signed in" do
      context "with non owner signed in" do
        before do
          request.session[:user_id] = user.id
          delete :destroy, { params: { id: product.id } }
        end

        it "sets a flash alert message" do
          expect(flash[:alert]).to be
        end

        it "redirects back to the product page" do
          expect(response).to redirect_to root_path
        end
      end

      context "with product creator signed in" do
        before do
          request.session[:user_id] = user.id
        end

        it "reduces the number of products in the database by 1" do
          product
          product_1

          before_count = Product.count
          delete :destroy, { params: { id: product_1.id } }
          after_count = Product.count

          expect(after_count).to eq(before_count - 1)
        end

        it "reduces the number of products by 1" do
          product_1
          expect{ delete :destroy, { params: {id: product_1.id} } }.to change { Product.count }.by(-1)
        end

        it "redirects to the products index page" do
          delete :destroy, { params: { id: product_1.id } }

          expect(response).to redirect_to(products_path)
        end

        it "sets a flash notice message" do
          delete :destroy, { params: { id: product_1.id } }
          expect(flash[:notice]).to be
        end
      end
    end

    context "with no user signed in" do
      it "redirect to the sign in page" do
        delete :destroy, params: { id: product.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "new" do
    context "with no signed in user" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "with signed in user" do
      before do
        request.session[:user_id] = user.id
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "assigns a product instance variable to a new Product" do
        get :new
        expect(assigns(:product)).to be_a_new Product
      end
    end
  end

  describe "#create" do
    context "user not signed in" do
      it "redirects to sign in page" do
        attributes = FactoryGirl.attributes_for(:product).merge(category_id: category.id, user_id: user.id)
        post :create, params: { product: attributes }
        expect(response).to redirect_to new_session_path
      end
    end

    context "user signed in" do
      before { request.session[:user_id] = user.id }

      context "with valid parameters" do
        def valid_request
          attributes = FactoryGirl.attributes_for(:product).merge(category_id: category.id, user_id: user.id)
          post :create, params: { product: attributes }
        end

        it "creates a new product in the database" do
          expect { valid_request }.to change { Product.count }.by(1)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end

        it "redirect to product show page" do
          valid_request
          expect(response).to redirect_to(product_path(Product.last))
        end

        it "associates the created product to the user" do
          valid_request
          expect(Product.last.user).to eq(user)
        end

        # it "associates the created product to the user" do
        #   valid_request
        #   expect(Product.last.user).to eq(user)
        # end
      end

      context "with invalid parameters" do
        def invalid_request
          attributes = FactoryGirl.attributes_for(:product).merge(title: nil, category_id: category.id, user_id: user.id)
          post :create, params: { product: attributes }
        end

        it "doesn't create a record in the database" do
          expect { invalid_request }.to change { Product.count }.by(0)
        end

        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "sets a flash message" do
          invalid_request
          expect(flash[:alert]).to be
        end
      end
    end
  end

  describe "#edit" do
    context "user not signed in" do
      before { get :edit, params: { id: product.id } }

      it "redirects to sign in page" do
        expect(response).to redirect_to new_session_path
      end
    end

    context "owner user signed in" do
      before do
        request.session[:user_id] = user.id
        get :edit, params: { id: product_1.id }
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end

      it "sets a product instance variable with the id passed" do
        expect(assigns(:product)).to eq(product_1)
      end
    end

    context "with non-owner user signed in" do
      before do
        request.session[:user_id] = user.id
        get :edit, params: { id: product.id }
      end

      it "redirects back to product page" do
        expect(response).to redirect_to root_path
      end

      it "sets a flash message" do
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#update" do
    context "with user not signed in" do
      it "redirects new session path" do
        patch :update, params: { id: product_1.id, product_1: { title: "some valid title" } }
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "with owner user signed in" do
      before { request.session[:user_id] = user.id }

      def valid_attributes(new_attributes = {})
        FactoryGirl.attributes_for(:product).merge(new_attributes)
      end

      context "with valid attributes" do
        before do
          params = { id: product_1.id, product: valid_attributes(title: 'New Title') }
          patch :update, params: params
        end

        it "updates the record in the database" do
          expect(product_1.reload.title).to eq('New Title')
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(product_path(product_1))
        end

        it "sets a flash message" do
          expect(flash[:notice]).to be
        end
      end

      context "with invalid attributes" do
        before do
          params = { id: product_1.id, product: valid_attributes(title: '') }
          patch :update, params: params
        end

        it "doesn't update the record in the database" do
          expect(product_1.reload.title).to_not eq('')
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end
    end

    context "with non-owner user signed in" do
      before do
        request.session[:user_id] = user.id
        params = { id: product.id, product: { title: 'New Title' } }
        patch :update, params: params
      end

      context "with non-owner signed in" do
        it "redirects back to product page" do
          expect(response).to redirect_to root_path
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end
    end
  end
end
