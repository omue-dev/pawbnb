# db/seeds.rb
# -------------------------------------------------
# Seeds data for:
# - 10 hosts (each owns one dog-friendly hotel)
# - 1 guest
# - Each hotel has 5 attached photos
# - 3–5 random bookings
# -------------------------------------------------

require "faker"
require "open-uri"

puts "🔥 Cleaning up database..."
Booking.destroy_all
Hotel.destroy_all
User.destroy_all

puts "✨ Creating users..."

# 10 hosts
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: "123456",
    email: Faker::Internet.unique.email,
    address: Faker::Address.city,
    role: "host"
  )
end

# 1 guest
guest = User.create!(
  first_name: "Guesty",
  last_name: "McGuestface",
  password: "123456",
  email: "guest@example.com",
  address: "Berlin, Germany",
  role: "guest"
)

puts "✅ Created #{User.count} users (10 hosts + 1 guest)."

hosts = User.where(role: "host")

puts "🏨 Creating hotels with fun dog-friendly names and multiple photos..."

# Punny yet believable dog-friendly hotel names
doggo_names = [
  "The Barkside Inn",
  "Pawradise Lodge",
  "Fur Seasons Resort",
  "The Wagmore Retreat",
  "Howliday Haven",
  "The Fetchington Hotel",
  "Tailwag Terrace",
  "The Snugglewood Cabin",
  "Pupper’s Peak Lodge",
  "Le Woof Boutique Stay"
]

# Scenic, dog-friendly place photos (Unsplash)
place_images = [
  "https://images.unsplash.com/photo-1566073771259-6a8506099945",
  "https://images.unsplash.com/photo-1551888418-2905d0e6f82c",
  "https://images.unsplash.com/photo-1505691938895-1758d7feb511",
  "https://images.unsplash.com/photo-1496417263034-38ec4f0b665a",
  "https://images.unsplash.com/photo-1501117716987-c8e1ecb210af",
  "https://images.unsplash.com/photo-1560184897-67f4b4e70b82",
  "https://images.unsplash.com/photo-1493809842364-78817add7ffb",
  "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
  "https://images.unsplash.com/photo-1533777324565-a040eb52fac1",
  "https://images.unsplash.com/photo-1499955085172-a104c9463ece",
  "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1",
  "https://images.unsplash.com/photo-1502920917128-1aa500764b43",
  "https://images.unsplash.com/photo-1519824145371-296894a0daa9",
  "https://images.unsplash.com/photo-1528909514045-2fa4ac7a08ba",
  "https://images.unsplash.com/photo-1501117716987-c8e1ecb210af"
]

hosts.each_with_index do |host, index|
  hotel = Hotel.create!(
    name: doggo_names[index],
    description: Faker::Lorem.paragraph(sentence_count: 3),
    address: Faker::Address.full_address,
    price_per_night: rand(70..250),
    user: host
  )

  # attach 5 random scenic photos
  place_images.sample(5).each_with_index do |img_url, i|
    file = URI.open(img_url)
    hotel.photos.attach(io: file, filename: "hotel_#{hotel.id}_#{i + 1}.jpg", content_type: "image/jpg")
  end
end

puts "✅ Created #{Hotel.count} hotels with 5 dog-friendly place photos each."

puts "📅 Creating bookings..."

hotels = Hotel.all
rand(3..5).times do
  hotel = hotels.sample
  start_date = Faker::Date.forward(days: rand(2..10))
  end_date = start_date + rand(1..5)
  total_price = (end_date - start_date).to_i * hotel.price_per_night

  Booking.create!(
    start_date: start_date,
    end_date: end_date,
    total_price: total_price,
    status: ["confirmed", "pending", "cancelled"].sample,
    user: guest,
    hotel: hotel
  )
end

puts "✅ Created #{Booking.count} bookings."
puts "🎉 Seeding complete — with punny hotels and Cloudinary uploads! 🐕🌴"
