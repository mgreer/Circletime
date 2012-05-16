# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

WorkUnit.create([{ :name => 'day', :hours => 24 }, { :name => 'hour', :hours => 1 }])
JobType.create( :name => 'Babysitter', :work_unit => WorkUnit.find_by_name( 'hour' ), :stars => 1, :is_misc => false )
JobType.create( :name => 'Petsitter', :work_unit => WorkUnit.find_by_name( 'day' ), :stars => 1, :is_misc => false )
JobType.create( :name => 'Favor', :work_unit => WorkUnit.find_by_name( 'day' ), :stars => 1, :is_misc => true )