class ProductsController < ApplicationController

  def index
    @products = Product.order(created_at: :desc)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    # byebug

    if @product.save
      flash[:notice] = "Product created successfully"
      # redirect_to home_path
      # redirect_to new_product_path
      redirect_to @product
    else
      flash[:alert] = "Problem creating your product"
      render :new
    end
  end

  def show
    @product = Product.find params[:id]
  end

  def destroy
    @product = Product.find params[:id]
    @product.destroy
    redirect_to products_path
  end

  def edit
    @product = Product.find params[:id]
  end

  def update
    @product = Product.find params[:id]

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
    params.require(:product).permit(:title, :description, :price)
  end
end
