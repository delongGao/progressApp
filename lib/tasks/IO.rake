require 'csv'

namespace :fileIO do

  task :inject do |file_in,file_out1,file_out2|
  #def self.myio(file_in,file_out1,file_out2)
    directory = "data/realdata"
    path = Rails.root.join(directory).to_s
    target_input = "#{path}/#{file_in}.csv"
    target_output1 = "#{path}/#{file_out1}.csv"
    target_output2 = "#{path}/#{file_out2}.csv"

    input_hash = {}
    i = 1
    CSV.foreach(target_input) do |row|
      word, definition = row
      # write first file
      CSV.open(target_output1, "ab") do |csv|
        csv << [i, definition]
      end

      # write second file
      CSV.open(target_output2, "ab") do |csv|
        csv << [i, word, 0, 0, 10, i]
      end
      i + 1
    end
  end

  #FileIO.myio("words_source.csv","answers.csv","words.csv")
end