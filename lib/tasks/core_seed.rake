# We set this dynamically, so that the karl:xxx (e.g. clean)
# Application name defined in config/application.rb.
app_name = Rails.application.class.to_s.split("::").first

# Core - first seed for application settings (always used)
namespace "#{app_name}" do
  desc "Core Seed - for all deployments."
  task :core_seed => :environment do

  Rake::Task["#{app_name}:basic_data"].invoke

  end # end core_seed


  desc "Populates data by importing a csv file."
  task :basic_data => :environment do
    puts "seeding data"

    # This should be a setting
    directory = "data/realdata"
    path = Rails.root.join(directory).to_s

    manifest_information = YAML.load_file("#{path}/manifest.yml")
    # Construct the shell command that we are going to run to import the sql.

    sql = ActiveRecord::Base.connection()

    puts "Loading #{manifest_information.count} data sets at #{Time.now}"
    tag_update_strs=[]
    sql.execute("SET GLOBAL sql_mode='NO_ENGINE_SUBSTITUTION'")
    manifest_information.each do |file_name,settings|
      specification = settings['specs']? settings['specs'] : "FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n'"
      target = "#{path}/#{file_name}.csv"
      puts "Loading #{target} at #{Time.now}"
      puts "Error: Cannot find file '#{target}' described in manifest" if(not File.exist?(target))
      puts "Error: No table name defined" if (not settings['table'])
      puts "Warning: No data Headers defined" if (not settings['header'])
      sql.execute("truncate  #{settings['table']};")
      execute_str = "LOAD DATA INFILE '#{target}' INTO TABLE #{settings['table']} #{specification}"
      execute_str += " (#{settings['header']})" if settings['header']

      sql.execute(execute_str)

      puts execute_str

      puts "Updating Timestamps"
      if settings.has_key?('timestamps')
        if settings['timestamps'].eql?('create_only')
          tag_update_strs << "UPDATE `#{settings['table']}` SET created_at = NOW(); "
        elsif settings['timestamps'].eql?('both')
          tag_update_strs << "UPDATE `#{settings['table']}` SET updated_at = NOW() , created_at = NOW(); "
        end
      else
        tag_update_strs << "UPDATE `#{settings['table']}` SET updated_at = NOW() , created_at = NOW(); "
      end

      puts settings['table']+" loaded."
    end

    puts "Updating Timestamps"
    tag_update_strs.each do |statement|
      sql.execute(statement)
    end

    puts "Imported #{manifest_information.count} data sets at #{Time.now}."

  end

end