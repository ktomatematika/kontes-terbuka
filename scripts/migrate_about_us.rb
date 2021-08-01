# frozen_string_literal: true

# This is a ruby script to migrate all about us entries
# Follow these steps at the app root to execute:
# bundle exec rails c
# load './scripts/migrate_about_us.rb'
# migrate()

def retrieve_panitia_or_admin
  User.joins(:roles).where('roles.name' => %w[panitia admin])
end

def process_about_us(panitia_or_admin, about_us_data)
  about_us_names = about_us_data.map do |about_us|
    about_us[:name].downcase
  end
  panitia_or_admin_names = panitia_or_admin.map do |user|
    user.fullname.downcase
  end
  existing = about_us_names.select do |name|
    panitia_or_admin_names.include?(name)
  end
  missing = about_us_names.select do |name|
    panitia_or_admin_names.exclude?(name)
  end
  [existing, missing]
end

def process_alumni(panitia_or_admin, alumni_data)
  alumni_names = alumni_data.map do |alumni|
    alumni[:name].downcase
  end
  panitia_or_admin_names = panitia_or_admin.map do |user|
    user.fullname.downcase
  end
  existing = alumni_names.select do |name|
    panitia_or_admin_names.include?(name)
  end
  missing = alumni_names.select do |name|
    panitia_or_admin_names.exclude?(name)
  end
  [existing, missing]
end

def create_about_users(data, panitia_or_admin, is_alumni)
  data.map do |about_us|
    image_path = about_us[:image]
    name = about_us[:name]
    description = about_us[:description]
    related_account_filter = panitia_or_admin.select { |user| user.fullname.downcase == name.downcase }
    next if related_account_filter.empty?

    File.open(Rails.root.join('app/assets/images/panitia', image_path), 'r') do |image|
      related_account = related_account_filter.first
      related_account.about_user = AboutUser.create(
        name: name,
        description: description,
        image: image,
        is_alumni: is_alumni
      )
      related_account.save
    end
  end
end

def migrate
  about_us_data = Kernel.eval(File.read(Rails.root.join('scripts/about_us_data.txt')))
  alumni_data = Kernel.eval(File.read(Rails.root.join('scripts/alumni_data.txt')))
  panitia_or_admin = retrieve_panitia_or_admin
  _existing_panitia_or_admin, missing_panitia_or_admin = process_about_us(panitia_or_admin, about_us_data)
  _existing_alumni, missing_alumni = process_alumni(panitia_or_admin, alumni_data)
  missing_users = missing_panitia_or_admin + missing_alumni
  all_missing_log = missing_users.reduce { |acc, elem| acc + "\n" + elem }
  create(about_us_data, panitia_or_admin, false)
  create(alumni_data, panitia_or_admin, true)
  puts all_missing_log
end
