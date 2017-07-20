class Admin::DashboardController < Admin::BaseController
  def index
    @stats = { product_count: Product.count,
               review_count:  Review.count,
               user_count:    User.count
             }

    @products = Product.all
    @reviews = Review.all
    @users = User.all
  end
  
end
