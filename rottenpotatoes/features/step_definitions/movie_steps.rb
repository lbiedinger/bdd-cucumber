# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

Then /I should(nt)? see the movies with the following ratings: (.*)/ do |hidden, ratings|
  ratings.split(",").map{|e| "#{e.strip}"}.each do |rating|
    Movie.where(rating: rating).each do |movie|
       page.should_not have_content(movie.title) if hidden
       page.should have_content(movie.title) unless hidden
    end
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").map{|e| "ratings_#{e.strip}"}.each do |rating|
    uncheck ? uncheck(rating) : check(rating)
  end
end

When /I check all the ratings/ do 
  Movie.all_ratings.map{|e| "ratings_#{e.strip}"}.each do |rating|
    check(rating)
  end
end

Then /I should see all the movies/ do
  Movie.all.each do |movie|
    page.should have_content(movie.title)
  end
end
