def get_primary_genre(genre_list):
	pgenre = {'Game':0, 'Entertainment':0, "Education":0}
	for genre in genre_list:
		pgenre.update({genre:1})
	return pgenre

def get_secondary_genre(genre_list):
	sgenre = {
	'Action':0, 
	'Adventure':0, 
	'Board':0, 
	'Card':0, 
	'Casual':0, 
	'Education':0, 
	'Family':0, 
	'Other':0, 
	'Puzzle':0, 
	'Role Playing':0, 
	'Simulation':0, 
	'Sports':0,
	'Strategy':0}
	for genre in genre_list:
		sgenre.update({genre:1})
	return sgenre

def get_age_rating(age_rating):
	age_ratings = {'above_four':0, 'above_nine':0, 'above_twelve':0, "above_seventeen":0}
	age_ratings.update({age_rating:1})
	return age_ratings