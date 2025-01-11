FROM python:3.10-slim-buster

# Set environment only for local testing
ENV DB_USERNAME=mypostgresuser
ENV DB_PASSWORD=mypostgrespassword
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5433
ENV DB_NAME=mypostgresdb

# Create working directory
WORKDIR /analytics

# Set up python build requirements and ensure up to date
COPY ./analytics/requirements.txt requirements.txt
RUN apt update -y
RUN apt install -y build-essential libpq-dev
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Copy the application code
COPY ./analytics/*.py .

# Run the application
CMD python app.py