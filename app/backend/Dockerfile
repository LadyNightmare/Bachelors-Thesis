FROM python:3.8.11-slim-buster

RUN apt-get update && apt-get install -y libpq-dev gcc python3-dev musl-dev g++ libglib2.0-dev python3-opencv libopencv-dev
#postgresql-dev
# Installing build dependencies
# For python3 you need to add python3-dev *please upvote the comment
# of @its30 below if you use this*
COPY requirements.txt /
RUN pip3 install -r /requirements.txt
RUN pip3 install ipython
COPY ./src /app
COPY ./run.sh /app
COPY ./gunicorn.conf.py /app
WORKDIR /app
ENV PYTHONPATH /app
ENTRYPOINT ["./run.sh"]
