B1;3201;0c#!/usr/bin/ruby
################################################################################
# Tool to crawl for first or last names by gender & output them to a .txt file.
#
# Jayson Grace < jaysong@unm.edu >
# Version 1.0
# since 2013-03-24
#
################################################################################

require 'open-uri'
require 'pp'

# Global Variables
$last_names_url = 'http://random-name-generator.info/last-names/'
$female_first_name_url = 'http://random-name-generator.info/female-names/'
$male_first_name_url = 'http://random-name-generator.info/male-names/'
# copied info from http://homepage3.nifty.com/transjaws/Tips02.htm and put into text file for this to parse
$user_name = './usersPre_Parse.txt'

# Helper method for alphabet
def getAlphabet
  alphabet = "A".."Z"
  $alphabet_array = alphabet.to_a
end

# Pulled by hand
def getUser
  wordsArray = []
  open $user_name do |a|
    a.each do |line|
      line.gsub!(/\s+/, "")
      wordsArray << line
    end
  end
  puts wordsArray
#  wordsArray << line.split(/\w+/)

          #        txt << line
          #        txt << " #{$alphabet_array[alphaRand]}"
      #        print "#{line}" + "#{$alphabet_array[alphaRand]}"
    end
  end
  File.open("users.txt", "wb") do |txt|
    for i in 0..wordsArray.size
      puts wordsArray[i]
      #      if (/(\w+)/.match()
      puts i
    end
    #  end
  end
end


def getMale
  #  @male_first = []
  File.open("maleFirst.txt", "wb") do |txt|
    $alphabet_array.each do |letter|
      open $male_first_name_url + "#{letter}" do |a|
        a.each do |line|
          if (/\s+(#{letter}\w+)\s+/.match(line))
            txt << $1.chomp
            txt << "\n"
            #         @male_first << $1
          end
        end
      end
    end
  end
  # debug string to print out the array in its entirety
  #  @male_first.each {|male_name| puts male_name}
end

def getFemale
  File.open("femaleFirst.txt", "wb") do |txt|
    # @female_first = []
    $alphabet_array.each do |letter|
      open $female_first_name_url + "#{letter}" do |a|
        a.each do |line|
          if (/\s+(#{letter}\w+)\s+/.match(line))
            txt << $1.chomp
           txt << "\n"
            #         @female_first << $1
          end
        end
      end
    end
  end
  # debug string to print out the array in its entirety
  # @female_first.each {|female_name| puts female_name}
end

def getLast
  File.open("lastName.txt", "wb") do |txt|
    #  @last_name = []
    $alphabet_array.each do |letter|
      open $last_names_url + "#{letter}" do |a|
        a.each do |line|
          if (/\s+(#{letter}\w+)\s+/.match(line))
            txt << $1
            txt << "\n"
            #          @last_name << $1
          end
        end
      end
    end
  end
  # debug string to print out the array in its entirety
  #  @last_name.each {|last_name| puts last_name}
end

# Print out asking if you would like a list of male, female, or last names
puts "Hello, welcome to the names web crawler!"
puts "Uncomment the method for which you want to generate a txt file."

getAlphabet
#getMale
#getFemale
#getLast
getUser
