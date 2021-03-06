# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m #  /m means match across newlines
  page.body.should =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/, /).each do |rating|
    if (uncheck) then step "I uncheck \"ratings_#{rating}\""
    else 
      step "I check \"ratings_#{rating}\""
    end
  end
end

When /I check all of the ratings/ do
  Movie.all_ratings.each do |rating|
    step "I check \"ratings_#{rating}\""
  end
end

When /I check none of the ratings/ do
  Movie.all_ratings.each do |rating|
    step "I uncheck \"ratings_#{rating}\""
  end
end

Then /I should see movies with the following ratings: (.*)/ do |rating_list|
  rating_list.split(/, /).each do | rating |
    Movie.find_all_by_rating(rating).each do |movie|
       step "I should see \"#{movie.title}\""
    end
  end
end

Then /I should not see movies with the following ratings: (.*)/ do |rating_list|
  rating_list.split(/, /).each do | rating |
    Movie.find_all_by_rating(rating).each do |movie|
       step "I should not see \"#{movie.title}\""
    end
  end  
end

Then /I should see all of the movies/ do
  movie_count = Movie.find(:all).count
  page.has_css?("table#movies tr", :count => movie_count)
end

Then /I should see none of the movies/ do
  page.has_css?("table#movies tr", :count => 0)
end
