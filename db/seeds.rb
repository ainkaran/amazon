# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = 'supersecret'

Product.destroy_all
Category.destroy_all
User.destroy_all

User.create first_name: 'Ainkaran', last_name: 'Pathmanathan', email: 'pat.ainkaran@gmail.com', password: PASSWORD

10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}-#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end

users = User.all

1000.times do
  Product.create title: Faker::ChuckNorris.fact,
                  description: Faker::Hacker.say_something_smart,
                  user: users.sample
end

products = Product.all

products.each do |product|
  rand(1..5).times do
    Review.create(
      body: Faker::RickAndMorty.quote,
      product: product,
      user: users.sample
    )
  end
end

reviews = Review.all


categories = ['Books', 'Technology', 'Computers', 'Movies', 'TV', 'Fashion', 'Music']

categories.each do |category|
  Category.create(name: category)
end

1000.times do
  category = Category.all.sample

  p = Product.create(
    title: Faker::Superhero.name,
    description: Faker::Hipster.sentence,
    price: Faker::Commerce.price,
    category_id: category.id
  )
end

puts "#{Product.count} products created!"

puts Cowsay.say("Created #{users.count} users", :tux)
puts Cowsay.say('Created 1000 products', :cow)
puts Cowsay.say("Created #{reviews.count} reviews", :ghostbusters)
