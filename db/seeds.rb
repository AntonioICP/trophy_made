# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Product.create!([
  {
    name: "Clear Dorado Wedge Acrylic Award",
    SKU: "AC103",
    description: "From the best performing team to the highest salesperson, acknowledge those who have gone above and beyond with this award.\n\n**Decorating on the award is for illustration purposes only**",
    image_url: "https://trophymade.com/app/uploads/2023/04/AC103.webp",
    cloudinary_template_url: "https://trophymade.com/app/uploads/2022/02/AC103_T.png",
    price: 77.5
  },
  {
    name: "Black Dorado Wedge Acrylic Award",
    SKU: "AC103-K",
    description: "From the best performing team to the highest salesperson, acknowledge those who have gone above and beyond with this award.\n\n**Decorating on the award is for illustration purposes only**",
    image_url: "https://trophymade.com/app/uploads/2023/04/ACC09B-K.webp",
    cloudinary_template_url: "https://trophymade.com/app/uploads/2022/02/AC103_T.png",
    price: 77.5
  },
  {
    name: "Matterhorn Clear & Bronze Acrylic Award",
    SKU: "AC151A-Z",
    description: "From the best performing team to the highest salesperson, acknowledge those who have gone above and beyond with this award.\n\n**Decorating on the award is for illustration purposes only**",
    image_url: "https://trophymade.com/app/uploads/2023/04/AC151A-Z.webp",
    cloudinary_template_url: "https://trophymade.com/app/uploads/2022/02/AC151B-S_T.png",
    price: 121.74
  },
  {
    name: "Arch Clear Acrylic Award",
    SKU: "AC201-1",
    description: "From the best performing team to the highest salesperson, acknowledge those who have gone above and beyond with this award.\n\n**Decorating on the award is for illustration purposes only**",
    image_url: "https://trophymade.com/app/uploads/2023/04/AC201-1.webp",
    cloudinary_template_url: "https://trophymade.com/app/uploads/2022/02/AC201-1_T.png",
    price: 50.44
  },
  {
    name: "Peak Clear Acrylic Award",
    SKU: "AC201-2",
    description: "From the best performing team to the highest salesperson, acknowledge those who have gone above and beyond with this award.\n\n**Decorating on the award is for illustration purposes only**",
    image_url: "https://trophymade.com/app/uploads/2023/04/AC201-2.webp",
    cloudinary_template_url: "https://trophymade.com/app/uploads/2022/02/AC201-2_T.png",
    price: 50.44
  }
])
