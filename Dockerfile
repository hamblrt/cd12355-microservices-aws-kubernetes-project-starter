FROM python:3.10-slim-buster

# Create working directory
WORKDIR /analytics

# Set up python build requirements and ensure up to date
COPY ./analytics/requirements.txt requirements.txt
RUN apt update -y
RUN apt install -y build-essential libpq-dev
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Copy the application code
COPY ./analytics/*.py ./

# Run the application
CMD python app.py