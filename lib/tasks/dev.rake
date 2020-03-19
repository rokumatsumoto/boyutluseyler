if Rails.env.development? || Rails.env.test? || ENV['ADMIN']

  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: :environment do
      Faker::UniqueGenerator.clear

      steps = 9

      illustration_source = 'https://picsum.photos'
      illustration_large_size = 480
      illustration_medium_size = 234
      illustration_thumb_size = 113
      illustration_content_type = 'image/jpeg'
      illustration_format = 'jpg'

      blueprint_image_source = 'https://picsum.photos'
      blueprint_image_thumb_size = 113
      blueprint_content_type = 'application/vnd.ms-pki.stl'
      blueprint_image_format = 'jpg'

      avatar_source = 'https://api.adorable.io/avatars'
      avatar_medium_size = 160
      avatar_thumb_size = 36
      avatar_format = 'jpeg'

      design_illustrations = {}
      design_blueprints = {}

      p "1/#{steps} Creating Users"

      UsersRole.delete_all
      Role.delete_all
      Identity.delete_all
      User.delete_all

      10.times do
        name = Faker::Name.unique.name
        username = Faker::Internet.unique.username(specifier: name)
        User.create!(
          email: Faker::Internet.email(name: name, separators: '+'),
          username: username,
          password: 'password',
          confirmed_at: Time.current,
          avatar_url: "#{avatar_source}/#{avatar_medium_size}/#{username}.#{avatar_format}",
          avatar_thumb_url: "#{avatar_source}/#{avatar_thumb_size}/#{username}.#{avatar_format}"
        )
      end

      p "2/#{steps} Creating Illustrations"

      Illustration.delete_all

      100.times do |i|
        illustrations_count = rand(1..13)

        illustration_ids = []

        illustrations_count.times do
          illustration_id = rand(1..1000)

          illustration = Illustration.create!(
            url: "#{illustration_source}/id/#{illustration_id}/#{illustration_large_size}/#{illustration_large_size}.#{illustration_format}",
            url_path: "#{illustration_source}/id/#{illustration_id}/#{illustration_large_size}/#{illustration_large_size}.#{illustration_format}",
            size: 35_029,
            content_type: illustration_content_type,
            large_url: "#{illustration_source}/id/#{illustration_id}/#{illustration_large_size}/#{illustration_large_size}.#{illustration_format}",
            medium_url: "#{illustration_source}/id/#{illustration_id}/#{illustration_medium_size}/#{illustration_medium_size}.#{illustration_format}",
            thumb_url: "#{illustration_source}/id/#{illustration_id}/#{illustration_thumb_size}/#{illustration_thumb_size}.#{illustration_format}"
          )

          illustration_ids << illustration.id
          design_illustrations[i] = illustration_ids
        end
      end

      p "3/#{steps} Creating Blueprints"

      Blueprint.delete_all

      100.times do |i|
        blueprints_count = rand(1..8)

        blueprint_ids = []

        blueprints_count.times do
          blueprint_id = rand(1..1000)

          blueprint = Blueprint.create!(
            url: "#{Boyutluseyler.config[:direct_upload_endpoint]}/bowser_low_poly_flowalistik223.STL",
            url_path: 'bowser_low_poly_flowalistik223.STL',
            size: 32_484,
            content_type: blueprint_content_type,
            thumb_url: "#{blueprint_image_source}/id/#{blueprint_id}/#{blueprint_image_thumb_size}/#{blueprint_image_thumb_size}.#{blueprint_image_format}"
          )

          blueprint_ids << blueprint.id
          design_blueprints[i] = blueprint_ids
        end
      end

      p "4/#{steps} Creating Designs"

      Design.delete_all
      FriendlyId::Slug.where(sluggable_type: 'Design').delete_all
      Gutentag::Tagging.where(taggable_type: 'Design').delete_all
      Gutentag::Tag.delete_all

      Design.invalidate_most_downloaded_cache
      Design.invalidate_popular_designs_cache
      # Category.invalidate_all_categories_cache # TODO: activate after this PR https://github.com/rokumatsumoto/boyutluseyler/pull/97

      blueprint_extensions = %i[STL OBJ PLY ZIP]
      user_ids = User.ids
      category_ids = Category.ids

      100.times do |i|
        Design.create!(
          name: Faker::Book.unique.title,
          description: Faker::Hipster.unique.paragraphs(number: rand(1..5)).map { |pr| "<p>#{pr}</p>" }.join,
          printing_settings:
          [
            "Dolgu: #{rand(1..50)}%",
            "Kalite: #{rand(0.05..0.14).round(2)}mm",
            "Hız: #{rand(50..150)}mm / s",
            "#{Faker::Construction.heavy_equipment} üzerinde #{Faker::Science.element} ile basılmıştır."
          ].map { |pr| "<p>#{pr}</p>" }.join,
          model_file_format: i % 5 == 0 ? 'STL ve ZIP' : blueprint_extensions.sample,
          license_type: Design.license_types.keys.sample,
          allow_comments: i % 11 != 0,
          user_id: user_ids[rand(0..user_ids.count - 1)],
          category_id: category_ids[rand(0..category_ids.count - 1)],
          tags_as_string: Faker::Hipster.words(number: rand(1..10)).join(', '),
          created_at: Faker::Time.backward(days: 60),
          illustration_ids: design_illustrations[i],
          blueprint_ids: design_blueprints[i]
        )
      end

      p "5/#{steps} Creating Design Downloads"

      DesignDownload.delete_all

      Design.all.each do |design|
        DesignDownload.create!(
          step: 'ready',
          url: 'uploads/design_zip/file/1/esttstest20191027-2jfu7iv8.zip',
          design: design
        )
      end

      p "6/#{steps} Creating Download Events"

      event_name = Ahoy::Event::DOWNLOADED_DESIGN
      visit_ids = Ahoy::Event.where_event(event_name).pluck(:visit_id)
      Ahoy::Event.where_event(event_name).delete_all
      Ahoy::Visit.delete(visit_ids)

      Design.all.each do |design|
        rand(1..100).times do
          ahoy = Ahoy::Tracker.new(user: User.order('RANDOM()').first)
          ahoy.track(event_name, design_id: design.id)
        end
      end

      Design.all.each do |design|
        Designs::Downloads::HourlyDownloadsCountService.new.execute_for_design(design)
      end

      p "7/#{steps} Creating Visit Events"

      event_name = Ahoy::Event::VIEWED_DESIGN
      visit_ids = Ahoy::Event.where_event(event_name).pluck(:visit_id)
      Ahoy::Event.where_event(event_name).delete_all
      Ahoy::Visit.delete(visit_ids)

      Design.all.each do |design|
        rand(1..100).times do
          ahoy = Ahoy::Tracker.new(user: User.order('RANDOM()').first)
          ahoy.track(event_name, design_id: design.id)

          Designs::PageViews::PopularityScoreService.new(design).execute
        end
      end

      p "8/#{steps} Creating Like Events"

      event_name = Ahoy::Event::LIKED_DESIGN
      visit_ids = Ahoy::Event.where_event(event_name).pluck(:visit_id)
      Ahoy::Event.where_event(event_name).delete_all
      Ahoy::Visit.delete(visit_ids)

      Design.all.each do |design|
        rand(1..30).times do
          ahoy = Ahoy::Tracker.new(user: User.order('RANDOM()').first)
          ahoy.track(event_name, design_id: design.id)
        end
      end

      p "9/#{steps} Creating User Avatars"

      UserAvatar.delete_all

      User.all.each do |user|
        UserAvatar.create!(
          letter_avatar_url: user.avatar_url,
          letter_avatar_thumb_url: user.avatar_thumb_url,
          user: user
        )
      end
    end
  end
end
