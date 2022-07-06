#!/usr/bin/env ruby
# ruby script to read csv file
require 'csv'

# file = 'member_repos.csv'
file = '2022-07-06@14:50-member-repos.csv'
results_file = "#{file}-results.csv"
# open csv
CSV.foreach(file) do |row|
  # get member name
  member = row[0]
  # get repos
  repos = row[1]
  repos.gsub!(/\[|\]|\"|\s+/, '')
  repos.split(',').each do |repo|
    puts repo
    # run system command to call trufflehog
    truffle_return = `trufflehog git #{repo}`
    # write results to csv
    CSV.open(results_file, 'a', force_quotes: false) do |csv|
      csv << [member, repo, truffle_return]
    end
  end
end
