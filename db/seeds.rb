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
        key: 'w7zijcg8xc4kit0d0y051nxdygen',
        filename: 'fish_for_seeds.jpg',
        content_type: 'image/jpeg',
        metadata: '{"identified":true,"width":540,"height":360,"analyzed":true}',
        service_name: 'cloudinary',
        byte_size: 27909,
        checksum: '/1UkXdyBz4cr1bGPz36aLQ=='
    )
    (1..19).each do |water_bioresource_id|
        ActiveStorage::Attachment.create!(
            record_type: 'WaterBioresource',
            record_id: water_bioresource_id,
            name: 'bioresource_photo',
            blob_id: 1
        )
    end

    15.times do
        RatePenalty.create(
            water_bioresource_id: Faker::Number.unique.between(from: 1, to: 20),
            money: Faker::Number.between(from: 1000, to: 5000)
        )
    end

    (1..15).each do |water_bioresource_id|
        (1..3).each do |where_catch|
            CatchRate.create(
                water_bioresource_id: water_bioresource_id,
                where_catch: where_catch,
                length: Faker::Number.decimal(l_digits: 2, r_digits: 1)
            )
        end
        CatchRate.create(
            water_bioresource_id: water_bioresource_id,
            where_catch: 0,
            length: 0.0
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