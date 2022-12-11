# init a base image (python 3.11)
FROM python:3.11.1-slim-bullseye

# update pip
RUN pip install --upgrade pip

# define the working directory
WORKDIR /server

# copy contents of the server directory to the working directory
COPY . /server

# run pip install
RUN pip install -r requirements.txt

# define the command to run the server
CMD ["python", "run.py"]