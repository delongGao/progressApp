#
# Karl is small set of tasks that help manage basic seeding, etc...
#
namespace :karl do
  desc "Drop, Create, Migrate, Seed, Prepare, Load, Test"
  task :clean, :env do |t, args|
    args.with_defaults(:env => Rails.env)

    puts " "
    puts " "
    puts "Hi, I'm Karl. I'm the cleaner."
    puts " "
    puts "Your environment: #{args[:env]}"

    # drop, create, migrate
    Rake::Task['karl:build'].invoke

    # check that dependent files exist
    Rake::Task['karl:file_dependencies'].invoke

    #if args[:env] == 'internal'
    #else
    #end

    # seed
    Rake::Task['karl:seed_all'].invoke

    # test - do a prepare, load, test
    Rake::Task['karl:test'].invoke

    puts " "
    puts "Karl, the cleaner, is complete."
    puts " "
  end

  desc "Migrate, Prepare, Load, Test"
  task :update, :env do |t, args|
    args.with_defaults(:env => Rails.env)

    puts " "
    puts " "
    puts "Hi, I'm Karl. I'm now updating your environment."
    puts " "
    puts "Your environment: #{args[:env]}"

    #if args[:env] == 'internal'
    #else
    #end

    Rake::Task['db:migrate'].invoke

    # test - do a prepare, load, test
    Rake::Task['karl:test'].invoke

    puts " "
    puts "Karl, the updater, is complete."
    puts " "
  end

  desc "Drop, Create, Migrate"
  task :build do

    if Rails.env.production?
      puts " "
      puts "!!!!Danger Will Robinson! Danger! - Production Detected!"
      Rake::Task['karl:db_you_sure?'].invoke
    end

    puts " "
    puts "Dropping Database"
    Rake::Task['db:drop'].invoke
    puts " "
    puts "Creating Database"
    Rake::Task['db:create'].invoke
    puts " "
    Rake::Task['karl:mig'].invoke
  end

  # run all tests except integration
  desc "Prepare, Load, Test (no integrations)"
  task :test do
    Rake::Task['karl:test_prepare'].invoke
    puts "Testing"
    Rake::Task['test:units'].invoke
    Rake::Task['test:functionals'].invoke
    puts " "
  end

  desc "Prepare, Load, Test with code coverage enabled"
  task :test_coverage do
    require 'simplecov'
    SimpleCov.start 'rails'

    puts " "
    puts " "
    puts "Hi, I'm Karl. I'm enabling running test with code coverage enabled."
    puts " "

    # Save the state of the COVERAGE environment variable
    coverage = ENV["COVERAGE"]

    # Set the COVERAGE env. variable to true (so coverage runs for tests)
    puts "Enabling Code Coverage"
    ENV["COVERAGE"] = "true"

    SimpleCov.command_name "karl"
    Rake::Task['karl:test_all'].invoke
    # Restore the prev value of the COVERAGE env. variable
    ENV["COVERAGE"] = coverage
  end

  desc "Test All"
  task :test_all do
    Rake::Task['karl:test_prepare'].invoke
    puts "Testing"
    Rake::Task['test'].invoke
    puts " "
  end

  desc "Seed All (core, internal, seed)"
  task :seed_all do
    # seed - the std seeds are based on app names so we don't have to change
    # them when we make new apps.
    app_name = Rails.application.class.to_s.split("::").first
    Rake::Task["#{app_name}:core_seed"].invoke
    Rake::Task["#{app_name}:internal_seed"].invoke
    Rake::Task['db:seed'].invoke
  end

  task :test_prepare do
    puts " "
    puts "Preparing Tests"
    Rake::Task['db:test:prepare'].invoke
    puts " "
    puts "Loading Tests"
    Rake::Task['db:test:load'].invoke
    puts " "
  end

  # Migrates
  task :mig do
    puts "Migrating Database"
    Rake::Task['db:migrate'].invoke
    puts " "
  end

  # Check that dependent files exist
  task :file_dependencies do
    puts " "

    # is postfix running?
    #postfix_processes = `ps -ax | grep -c [p]ostfix`.strip
    #if postfix_processes.to_i.eql?(0)
    #  puts "Warning: postfix mailer is not running!"
    #  print "Would you like to start it? (y or n): "
    #  if STDIN.gets.strip.downcase.starts_with?('y')
    #    `sudo postfix start`
    #  end
    #  puts " "
    #end


    # does imagemagick exist?
    #imagemagick_convert_file = `which convert`.strip
    #if File.exists? imagemagick_convert_file
    #  puts "imagemagick is installed at #{imagemagick_convert_file}"
    #else
    #  puts "imagemagick is not installed"
    #  exit!
    #end

    # is the imagemagick convert path defined correctly in Settings?
    #imagemagick_convert_path_array = imagemagick_convert_file.split("/")
    #imagemagick_convert_path_array.slice!(-1)
    #imagemagick_convert_path = imagemagick_convert_path_array.join("/") + "/"
    #if Settings.imagemagick_convert_path.eql?(imagemagick_convert_path)
    #  puts "Settings.imagemagick_convert_path value is correctly set to '#{imagemagick_convert_path}'"
    #else
    #  puts "set Settings.imagemagick_convert_path value to '#{imagemagick_convert_path}'"
    #  exit!
    #end

    puts " "
  end

  # From: https://gist.github.com/129590
  task :db_you_sure? do
    puts "!!!WARNING!!! This task will DESTROY your env's database!"
    puts "Continue? y/n"
    continue = STDIN.gets.chomp
    unless continue == 'y'
      puts "Exiting..."
      exit!
    end # end unless
  end # end you_sure
end