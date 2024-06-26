require "faker"

case Rails.env
when "development"

    User.create(
        email: "svetabotiuk@gmail.com",
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "admin"
    )

    User.create(
        email: "staff@gmail.com",
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "staff"
    )

    3.times do
        password = Faker::Internet.password(min_length: 6)
        User.create(
        email: Faker::Internet.unique.email(domain: 'mail.ua'),
        password: password,
        password_confirmation: password,
        role: "staff"
    )
    end

    User.create(
        email: "user@gmail.com",
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
    )

    14.times do
        password = Faker::Internet.password(min_length: 6)
        User.create(
            email: Faker::Internet.unique.email(domain: 'mail.com'),
            password: password,
            password_confirmation: password
        )
    end

    20.times do
        WaterBioresource.create(
            name: Faker::Creature::Animal.unique.name.capitalize,
            latin_name: Faker::Artist.unique.name.capitalize,
            resource_type: WaterBioresource.resource_types.keys.sample
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
        ActionText::RichText.create!(
            record_type: 'WaterBioresource',
            record_id: water_bioresource_id,
            name: 'bioresource_description',
            body: Faker::Lorem.paragraph_by_chars
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
            length: [0.0, 5.5, 10.1].sample
        )
    end

    water_bioresource_small_fish_ids = WaterBioresource.where(resource_type: "small_fish").pluck(:id)
    water_bioresource_invertebrate_ids = WaterBioresource.where(resource_type: "invertebrate").pluck(:id)
    water_bioresource_with_catch_rate_ids = CatchRate.pluck(:water_bioresource_id).uniq
    water_bioresource_ids = water_bioresource_small_fish_ids & water_bioresource_with_catch_rate_ids
    water_bioresource_ids.each do |water_bioresource_id|
        DayRate.create(
            water_bioresource_id: water_bioresource_id,
            catch_amount: 0,
            amount_type: DayRate.amount_types.keys.sample
        )
    end
    water_bioresource_ids = water_bioresource_invertebrate_ids & water_bioresource_with_catch_rate_ids
    water_bioresource_ids.each do |water_bioresource_id|
        DayRate.create(
            water_bioresource_id: water_bioresource_id,
            catch_amount: Faker::Number.between(from: 1, to: 30),
            amount_type: DayRate.amount_types.keys.sample
        )
    end

    user_ids = User.pluck(:id)
    user_ids.each do |user_id|
        10.times do
            FishingPlace.create(
                name: Faker::Lorem.unique.word.capitalize,
                description: Faker::Lorem.paragraph,
                where_catch: CatchRate.where_catches.keys.sample,
                user_id: user_id
            )
        end
        20.times do
            Tool.create(
                name: Faker::Coin.unique.name.capitalize,
                description: Faker::Quote.yoda,
                tool_type: Tool.tool_types.keys.sample,
                user_id: user_id
            )
        end
        Faker::UniqueGenerator.clear

        user_fishing_places_ids = FishingPlace.where(user_id: user_id).pluck(:id)
        15.times do
            start_time = Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now - 2.days)
            FishingSession.create(
                start_at: start_time,
                end_at:  start_time + rand(1..36).hours,
                user_id: user_id,
                fishing_place_id: user_fishing_places_ids.sample
            )
        end

        water_bioresource_ids = WaterBioresource.pluck(:id)
        user_fishing_sessions_ids = FishingSession.where(user_id: user_id).pluck(:id)
        25.times do
            Catch.create(
                catch_time: Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now),
                catch_length:  Faker::Number.decimal(l_digits: 2, r_digits: 1),
                catch_weight: Faker::Number.decimal(l_digits: 1, r_digits: 3),
                catch_result: "set_free",
                fishing_session_id: user_fishing_sessions_ids.sample,
                water_bioresource_id: water_bioresource_ids.sample
            )
        end

        user_catch_ids = Catch.joins(:fishing_place).where(fishing_place: {user_id: user_id}).pluck(:id)
        user_catch_ids.delete_at(0)
        user_tool_ids = Tool.where(user_id: user_id).pluck(:id)
        user_catch_ids.each do |user_catch_id|
            ActiveStorage::Attachment.create!(
                record_type: 'Catch',
                record_id: user_catch_id,
                name: 'catch_photos',
                blob_id: 1
            )
            rand(1..3).times do
                selected = ToolCatch.where(catch_id: user_catch_id).pluck(:tool_id)
                selected = [] unless selected.present?
                ToolCatch.create(
                    tool_id: (user_tool_ids - selected).sample,
                    catch_id: user_catch_id
                )                
            end
        end
    end

when "production"

    user = User.where(email: "svetabotiuk@gmail.com").first_or_initialize
    user.update!(
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "admin"
    )

end