# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Author.create(first_name: "Chetan", last_name: "Bhagat", age:36)
Author.create(first_name: "Amrita", last_name: "Pritam", age:41)
Author.create(first_name: "Jhumpa", last_name: "Lahiri", age:44)
Author.create(first_name: "Khushwant", last_name: "Singh", age:76)
Author.create(first_name: "R. K.", last_name: "Narayan", age:65)

50.times do |x|
  Book.create(title: Faker::Lorem.sentences(number: 1),
              author_id: Faker::Number.between(from:1, to: Author.count))
end