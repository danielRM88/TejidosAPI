# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
FactoryGirl.create(:fabric)
FactoryGirl.create(:fabric2)
FactoryGirl.create(:fabric3)
FactoryGirl.create(:fabric4)

FactoryGirl.create(:iva)
FactoryGirl.create(:iva2)
FactoryGirl.create(:iva3)

FactoryGirl.create(:supplier)
FactoryGirl.create(:supplier2)

FactoryGirl.create(:client)
FactoryGirl.create(:client2)
FactoryGirl.create(:client3)
FactoryGirl.create(:client4)

FactoryGirl.create(:purchase)
FactoryGirl.create(:purchase2)