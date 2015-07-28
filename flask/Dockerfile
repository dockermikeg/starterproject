FROM ubuntu
RUN apt-get -y update && apt-get -y install python-pip python-virtualenv python-psycopg2
RUN pip install Flask
RUN pip install Jinja2
RUN pip install psycopg2
RUN mkdir /workspace
RUN chmod 777 /workspace
ADD . /workspace
EXPOSE 5000
CMD python /workspace/hello.py

