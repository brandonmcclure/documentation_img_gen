FROM python:3

RUN sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list \
    && apt-get update -y && apt-get upgrade -y \
    && apt-get install ttf-mscorefonts-installer=3.8 -y --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src
# Copy the requirements file and install pip dependencies first to make use of build caching https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#leverage-build-cache
COPY requirements.txt /src
RUN pip install --no-cache-dir -r requirements.txt

COPY . /src

USER 1000
EXPOSE 7860

ENTRYPOINT ["python3", "/src/main.py"]