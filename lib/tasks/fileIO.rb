require 'csv'

class FileIOClass
  def self.myio(file_in,file_out1,file_out2)
    puts ""
    puts "set routes"
    puts ""
    directory = "data/realdata"
    path = "/Users/Tyemill/Projects/randomP/progressApp/" + directory
    target_input = "#{path}/#{file_in}"
    target_output1 = "#{path}/#{file_out1}"
    target_output2 = "#{path}/#{file_out2}"

    #input_hash = {}
    puts ""
    puts "let's get started"
    puts ""
    i = 1
    CSV.foreach(target_input) do |row|
      word, definition = row
      # write first file
      CSV.open(target_output1, "ab") do |csv|
        csv << [i, definition, i]
      end

      # write second file
      CSV.open(target_output2, "ab") do |csv|
        csv << [i, word, 0, 0, 10]
      end

      # update processing information
      print "."
      #puts ""
      #puts "processing " + i.to_s
      #puts ""
      i = i + 1
    end

    puts ""
    puts "finished"
  end
end

#FileIOClass.myio("words_source.csv","answers.csv","words.csv")