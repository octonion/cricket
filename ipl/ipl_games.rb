#!/usr/bin/ruby1.9.3

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base = "http://www.thatscricket.com/ipl/" #2012/results/"

first_year = 2008
last_year = 2013

#//*[@id="cricket-leftPanel"]/div[3]/table/tbody/tr[2]/td/table/tbody/tr[8]/td[3]

#path = '//*[@id="cricket-leftPanel"]/div[3]/table/tbody/tr[2]/td/table/tbody' #/tr[2]

path = '//*[@id="cricket-leftPanel"]/div[3]/table/tr[2]/td/table/tr' #[8]/td[3]

(first_year..last_year).each do |year|

  print "Pulling #{year}\n"

  games = CSV.open("ipl_games_#{year}.csv","w")

  url = "#{base}/#{year}/results/"

  begin
    page = agent.get(url)
  rescue
#    print "  -> #{year} not found\n"
    next
  end

  page.parser.xpath(path).each do |tr|
    row = [year]
    tr.xpath('td').each_with_index do |td,i|
      row += [td.text.strip]
    end
    if (row.size>1) then
      games << row
    end
  end

end
