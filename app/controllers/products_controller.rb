class ProductsController < ApplicationController

  # `before_action` can be used to run before any action in a controller.
  # The second argument is a symbol named after the method we would to run.
  # In this example, the before_action calls the find_question before say
  # the index, or new, etc.

  before_action :authenticate_user!, except: [:index, :show]

  before_action :find_product, only: [:show, :edit, :update, :destroy]
  # We can filter which methods the `before_action` will be called
  # by proving an `only:` argument giving an array symbols named after the actions.
  # There is also `except:`.

  before_action :authorize_user!, only: [:edit, :destroy, :update]

  def index
    # @products = Product.order(created_at: :desc)
    @products = Product.order(id: :desc).limit(10)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    # byebug

    @product.user = current_user

    if @product.save
      flash[:notice] = "Product created successfully"
      # redirect_to home_path
      # redirect_to new_product_path
      redirect_to @product

      # flash[:notice] = "Product created successfully"
      # redirect_to product_path(@product)

      # flash[:notice] = "Product created successfully"
      # redirect_to product_path(@product), notice: "Product created successfully"
    else
      # byebug
      flash[:alert] = "Problem creating your product"
      render :new
    end
  end

  def show
    # @product = Product.find params[:id]
  end

  def destroy
    # @product = Product.find params[:id]

    @product.destroy
    flash[:notice] = "Product successfully deleted."
    redirect_to products_path


  end

  def edit
    # @product = Product.find params[:id]
  end

  def update
    # @product = Product.find params[:id]

    if @product.update(product_params)
      flash[:notice] = "Product updated successfully"
      redirect_to product_path(@product)
    else
      flash[:alert] = "Problem updating your product"
      render :edit
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :category_id)
  end

  def find_product
    @product = Product.find(params[:id])
  end

  def authorize_user!
    # if @question.user != current_user
    # head :unauthorized unless can?(:manage, @question)
    unless can?(:manage, @product)
      flash[:alert] = "Access Denied."
      redirect_to root_path

      # head will send an empty HTTP response, it takes one argument as a symbol
      # and the argument will tell Rails to send the desired HTTP response code
      # 	:unauthorized -> 401
      # you can see more code on this page:
      # http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/
      # head :unauthorized
    end
  end

end
