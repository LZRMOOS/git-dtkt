#!/usr/bin/env ruby
# ruby script to use github octokit to get all members of an organization and their public repos
require 'csv'
require 'octokit'
require 'pry'

PAT = 'GITHUB_DTKT_TOKEN'.freeze
FMT = '.csv'.freeze

# get user options
# puts "Enter the name of the organization you want to get the members of:"
# org = gets.chomp
org = 'HelloFax'

member_repos = {}
client = Octokit::Client.new(access_token: ENV[PAT], auto_paginate: true)

client.org_members(org).each do |member|
  client.list_repos(member.login).each do |repo|
    puts member.login + '/' + repo.name
    member_repos[member.login] ||= []
    member_repos[member.login] << repo.clone_url
  end
end

# member = 'lzrmoos'
# client.list_repos(member).each do |repo|
#   puts member + '/' + repo.name
#   member_repos[member] ||= []
#   member_repos[member] << repo.clone_url
# end

file = "#{Time.now.strftime("%Y-%m-%d@%H:%M")}-member-repos" + FMT
CSV.open(file, 'w', force_quotes: false) do |csv|
  member_repos.each do |member, repos|
    csv << [member, repos]
  end
end

binding.pry()