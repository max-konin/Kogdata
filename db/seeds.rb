# coding: UTF-8
# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#arr2 = [[:name, :population]]
#arr2[1]

str = File.read 'db/CityBase.txt', :encoding =>  "utf-8"
arr = str.scan /[А-яа-я- ё]+\s\d+/

arr.each do |city|
  city_name = (city.scan /[А-яа-я- ё]+/).first.gsub(/\s$/, "")
  city_popu = (city.scan /\d+/).first
  City.create!(name: city_name, population: city_popu)
end