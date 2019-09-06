FROM python:3.7

ENV PYTHONUNBUFFERED 1

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -

RUN apt-get clean \
 && apt-get update -qq  \
 && apt-get install -y build-essential libpq-dev postgresql-client-10 libssl-dev imagemagick vim curl git

RUN mkdir /app
WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install gunicorn

ADD . /app

EXPOSE 8000

CMD exec gunicorn app.wsgi:application --bind 0.0.0.0:8000
