class Admin::DashboardController < Admin::BaseController
  def index
    @stats = { product_count: Product.count,
               review_count:  Review.count,
               user_count:    User.count
             }
  end
end
