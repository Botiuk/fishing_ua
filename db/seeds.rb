require "faker"

case Rails.env
when "development"

    User.create(
        email: "svetabotiuk@gmail.com",
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "admin"
    )

    20.times do
        WaterBioresource.create(
            name: Faker::Creature::Animal.unique.name.capitalize,
            latin_name: Faker::Artist.unique.name.capitalize
        )
    end

    ActiveStorage::Blob.create!(
        key: 'lrcfgmxre392x4ly19youxz9ru0q',
        filename: '01-goldfish-nationalgeographic.avif',
        content_type: 'image/avif',
        metadata: '{"identified":true,"width":3072,"height":1728,"analyzed":true}',
        service_name: 'cloudinary',
        byte_size: 46781,
        checksum: 'G7dBbX7Vyz3m80g71HdxQQ=='
    )
    (1..20).each do |water_bioresource_id|
        ActiveStorage::Attachment.create!(
            record_type: 'WaterBioresource',
            record_id: water_bioresource_id,
            name: 'bioresource_photo',
            blob_id: 1
        )
    end

when "production"

    user = User.where(email: "svetabotiuk@gmail.com").first_or_initialize
    user.update!(
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "admin"
    )

end