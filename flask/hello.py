import jinja2
import os
import psycopg2
import csv
import urllib2
from flask import Flask, Response, request, redirect

app = Flask(__name__)
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)

    
@app.route("/")
def hello():
    
    host=os.getenv('DB_PORT_5432_TCP_ADDR')
    port=os.getenv('DB_PORT_5432_TCP_PORT')
    print('host and port: %s, %s' % (host, port))
    postgres_connection = psycopg2.connect(database='mikeg', user='mikeg',
                                       password='notasecret', 
                                       host=host,
                                       port=port)
    cur = postgres_connection.cursor()
    cur.execute('SELECT * FROM stock_tickers')
    tickers = cur.fetchmany(10)
    template_values = { 'tickers':tickers }
    template = JINJA_ENVIRONMENT.get_template('get_symbol.html')
    cur.close()
    postgres_connection.close()
    return Response(template.render(template_values))

#http://real-chart.finance.yahoo.com/table.csv?s=AAPL&a=11&b=12&c=2014&d=06&e=27&f=2015&g=d&ignore=.csv
@app.route("/calculate", methods=['POST'])
def calculate():
    # get form input
    ticker=request.form['ticker']
    
    # download stock price history
    #url = "http://real-chart.finance.yahoo.com/table.csv?s=%s&g=d&ignore=.csv" % (ticker)
    #data = urllib2.urlopen(url)
    #cr = csv.reader(data)
    
    # connect to database
    host=os.getenv('DB_PORT_5432_TCP_ADDR')
    port=os.getenv('DB_PORT_5432_TCP_PORT')
    print('host and port: %s, %s' % (host, port))
    postgres_connection = psycopg2.connect(database='mikeg', user='mikeg',
                                       password='notasecret', 
                                       host=host,
                                       port=port)
    cur = postgres_connection.cursor()
    
    # run SQL commands
    cur.execute("""INSERT INTO stock_tickers (ticker_symbol) VALUES (%s)""", (ticker,))
    postgres_connection.commit()
    cur.close()
    postgres_connection.close()
    return redirect('/')

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)