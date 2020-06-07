from flask import * 
from html.parser import HTMLParser
import final_analysis
import data
import description_analysis

app = Flask(__name__)

@app.route('/')
def my_form():
    return render_template('form.html')

@app.route('/result/<game_name>/<reaction>')
def result(game_name, reaction):
  return render_template("result.html", game=game_name, reaction=reaction)

def get_reaction(game_name, pg_Game, sg_Game, price, iap, age, size):
    pgenre = data.get_primary_genre(pg_Game)
    sgenre = data.get_secondary_genre(sg_Game)
    age_rating = data.get_age_rating(age)
    num_result = final_analysis.predict([[
    	price,
    	iap,
    	size,
    	age_rating['above_twelve'],
    	age_rating['above_seventeen'],
    	age_rating['above_four'],
    	age_rating['above_nine'],
    	pgenre['Education'],
    	pgenre['Entertainment'],
    	pgenre['Game'],
    	sgenre['Action'],
    	sgenre['Adventure'],
    	sgenre['Board'],
    	sgenre['Card'],
    	sgenre['Casual'],
    	sgenre['Education'],
    	sgenre['Family'],
    	sgenre['Other'],
    	sgenre['Puzzle'],
    	sgenre['Role Playing'],
    	sgenre['Simulation'],
    	sgenre['Sports'],
    	sgenre['Strategy']]])

    if num_result == 1:
    	return "Hooray!"
    
    return "Uhoh!"

@app.route('/evaluate', methods=['POST'])
def my_form_post():
    game_name = request.form['game_name']
    pg_Game = request.form.getlist('pg_Game')
    sg_Game = request.form.getlist('sg_Game')
    price = request.form['price']
    iap = request.form['iap']
    age = request.form['age']
    size_in_mb = request.form['size']
    size = float(size_in_mb)*1000000
    desc = request.form['description']
    print (desc)
    reaction2 = description_analysis.predict_reaction(desc)
    print (reaction2)

    reaction = get_reaction(game_name, pg_Game, sg_Game, price, iap, age, size)
    return redirect(url_for('result', game_name=game_name, reaction=reaction))

app.run(host='0.0.0.0', port=3001)