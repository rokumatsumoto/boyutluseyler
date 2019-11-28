if Rails.env.development? || Rails.env.test?
  require 'faker/default/internet_tr'

  namespace :dev do
    desc 'Sample data for local development environment'
    task :prime do
      Faker::UniqueGenerator.clear

      image_source = 'https://picsum.photos'
      design_illustrations = {}
      design_blueprints = {}

      p '1/7 Creating Users'

      Faker::Config.locale = :tr

      User.delete_all

      10.times do |_i|
        name = Faker::Name.unique.name
        user = User.create!(
          email: Faker::Internet.email(name: name, separators: '+'),
          username: Faker::Default::InternetTr.unique.username(specifier: name),
          password: 'password',
          confirmed_at: Time.current
        )
      end

      p '2/7 Creating Illustrations'

      Illustration.delete_all

      100.times do |i|
        illustrations_count = rand(1..13)

        illustration_ids = []

        illustrations_count.times do |_ic|
          illustration_id = rand(1..1000)

          illustration = Illustration.create!(
            url: "#{image_source}/id/#{illustration_id}/480/480.jpg",
            url_path: "#{image_source}/id/#{illustration_id}/480/480.jpg",
            size: 35_029,
            content_type: 'image/jpeg',
            image_url: "#{image_source}/id/#{illustration_id}/113/113.jpg"
          )

          illustration_ids << illustration.id
          design_illustrations[i] = illustration_ids
        end
      end

      p '3/7 Creating Blueprints'

      Blueprint.delete_all

      100.times do |i|
        blueprints_count = rand(1..8)

        blueprint_ids = []

        blueprints_count.times do |_bc|
          blueprint_id = rand(1..1000)

          blueprint = Blueprint.create!(
            url: 'http://boyutluseyler-staging.s3-website.eu-central-1.amazonaws.com/uploaders/3/blueprint-file/ece88c67-b624-4855-9714-a53eeff9f4da/bowser_low_poly_flowalistik2 (4) (1).STL',
            url_path: 'uploaders/3/blueprint-file/ece88c67-b624-4855-9714-a53eeff9f4da/bowser_low_poly_flowalistik2 (4) (1).STL',
            size: 32_484,
            content_type: 'application/vnd.ms-pki.stl',
            image_url: "#{image_source}/id/#{blueprint_id}/113/113.jpg"
          )

          blueprint_ids << blueprint.id
          design_blueprints[i] = blueprint_ids
        end
      end

      p '4/7 Creating Designs'

      Design.delete_all
      FriendlyId::Slug.where(sluggable_type: 'Design').delete_all
      Gutentag::Tagging.where(taggable_type: 'Design').delete_all
      Gutentag::Tag.delete_all

      Faker::Config.locale = :en
      blueprint_extensions = %i[STL OBJ PLY ZIP]
      user_ids = User.pluck(:id)
      category_ids = Category.pluck(:id)

      design_downloads_count_list = {}

      100.times do |i|
        design = Design.create!(
          name: Faker::Book.unique.title,
          description: Faker::Hipster.unique.paragraphs(number: rand(1..5)).map { |pr| "<p>#{pr}</p>" }.join,
          printing_settings:
          [
            "Dolgu: #{rand(1..50)}%",
            "Kalite: #{rand(0.05..0.14).round(2)}mm",
            "Hız: #{rand(50..150)}mm / s",
            "#{Faker::Construction.heavy_equipment} üzerinde #{Faker::Science.element} ile basılmıştır."
          ].map { |pr| "<p>#{pr}</p>" }.join,
          model_file_format: i % 5 == 0 ? 'STL ve ZIP' : blueprint_extensions[rand(0..3)],
          license_type: Design.license_types.keys[rand(0..6)],
          allow_comments: i % 11 != 0,
          user_id: user_ids[rand(0..user_ids.count - 1)],
          category_id: category_ids[rand(0..category_ids.count - 1)],
          tag_names: Faker::Hipster.words(number: rand(1..10)),
          created_at: Faker::Time.backward(days: 60),
          illustration_ids: design_illustrations[i],
          blueprint_ids: design_blueprints[i]
        )

        design_downloads_count_list[design.id] = rand(0..10_000)
      end

      p design_downloads_count_list

      p '5/7 Creating Design Downloads'
      DesignDownload.delete_all

      Design.all.each do |design|
        DesignDownload.create!(
          step: 'ready',
          url: 'uploads/design_zip/file/2/esttstest20191027-garo4psc.zip',
          design: design
        )
      end

      p '6/7 Creating Download Events'

      event_name = 'Downloaded design'
      visit_ids = Ahoy::Event.where_event(event_name).pluck(:visit_id)
      Ahoy::Event.where_event(event_name).delete_all
      Ahoy::Visit.delete(visit_ids)

      Design.all.each do |design|
        design_downloads_count_list[design.id].times do |_dc|
          ahoy = Ahoy::Tracker.new(user: User.order('RANDOM()').first)
          ahoy.track(event_name, design_id: design.id)
        end
      end

      Design.all.each do |design|
        Designs::Downloads::HourlyDownloadsCountService.new.execute_for_design(design)
      end

      p '7/7 Creating Visit Events'

      event_name = 'Viewed design'
      visit_ids = Ahoy::Event.where_event(event_name).pluck(:visit_id)
      Ahoy::Event.where_event(event_name).delete_all
      Ahoy::Visit.delete(visit_ids)

      Design.all.each do |design|
        rand(1..100).times do |_dc|
          ahoy = Ahoy::Tracker.new(user: User.order('RANDOM()').first)
          ahoy.track(event_name, design_id: design.id)
        end
      end
    end
  end
end
