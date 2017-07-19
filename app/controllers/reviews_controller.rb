class ReviewsController < ApplicationController
  def create
      @review = Review.new(review_params)
      @product = Product.find(params[:product_id])
      @review.product = @product

      @user = current_user

      @review.user = @user

      if @review.save
        redirect_to @product, notice: 'Review Successfully Created!'
      else
        flash[:alert] = 'Review not created'
        render '/products/show'
      end
    end

    def destroy
      @review = Review.find(params[:id])

      if can?(:destroy, @review)
        @review.destroy
        redirect_to product_path(params[:product_id]), notice: 'Review Deleted!'
      else
        redirect_to product_path(params[:product_id]), alert: 'Review NOT Deleted!'
      end
    end

    private

    def review_params
      params.require(:review).permit(:body, :rating)
    end
end
