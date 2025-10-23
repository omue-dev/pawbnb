# db/seeds.rb
# -------------------------------------------------
# Seeds data for:
# - 10 hosts (each owns one dog-friendly hotel)
# - 1 guest
# - Each hotel has 5 attached photos (from existing Cloudinary URLs)
# - 3–5 random bookings
# -------------------------------------------------

require "faker"
require "open-uri"

puts "Cleaning up database..."
Booking.destroy_all
Hotel.destroy_all
User.destroy_all

puts "Creating users..."

# 10 hosts
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    address: Faker::Address.city,
    role: :host,
    password: "password123"
  )
end

# 1 guest
guest = User.create!(
  first_name: "Guesty",
  last_name: "McGuestface",
  email: "guest@example.com",
  address: "Berlin, Germany",
  role: :guest,
  password: "password123"
)

puts "Created #{User.count} users (10 hosts + 1 guest)."

hosts = User.where(role: :host)
puts "Creating hotels with existing Cloudinary images..."

# Dog-friendly hotel names
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

# Existing Cloudinary image URLs
place_images = [
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1761100435/development/kdpiezm9rb373xst30us1my475ed.jpg",
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1761100431/development/zf710f7dr1kh6pa9d8po6o2n8zis.jpg",
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1761100428/development/hbfwk0yb7gutfnfv657lllhisxae.jpg",
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1761100408/development/d2exapnl83ocv56vl31yvqv7c5hc.jpg",
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1761100400/development/vn0pk5lvntvantd39b34iccp0nb1.jpg",
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1761100392/development/gtr2t93aph7yl3bzt8nh1w4bdjl2.jpg",
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1761100380/development/v0l892ojte5krl3waxtaxgf0f2aa.jpg",
  "https://res.cloudinary.com/dtrtke9f2/image/upload/v1760169252/samples/animals/three-dogs.jpg"
]

created_hotels = 0

hosts.each_with_index do |host, index|
  hotel = Hotel.create!(
    name: doggo_names[index],
    description: Faker::Lorem.paragraph(sentence_count: 3),
    address: Faker::Address.full_address,
    price_per_night: rand(70..250),
    user: host
  )

  # Attach 5 pre-existing Cloudinary images without uploading
  start_index = (index * 5) % place_images.size
  subset = place_images.rotate(start_index).first(5)

  subset.each_with_index do |img_url, i|
    file = URI.open(img_url)
    hotel.photos.attach(
      io: file,
      filename: "hotel_#{hotel.id}_#{i + 1}.jpg",
      content_type: "image/jpg"
    )
  end

  created_hotels += 1
  puts "Created hotel: #{hotel.name}"
end

puts "Created #{created_hotels} hotels with Cloudinary images."

puts "Creating bookings..."

hotels = Hotel.all
if hotels.empty?
  puts "No hotels found — skipping booking creation."
else
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

  puts "Created #{Booking.count} bookings."
end

puts "Seeding complete."
