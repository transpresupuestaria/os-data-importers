FROM python:3.6-alpine

RUN apk add --update --no-cache \
    build-base \
    ca-certificates \
	g++ \
    git \
    libffi \
    libffi-dev \
    libpq \
    libxml2-dev \
    libxslt-dev \
    nodejs-npm \
    nodejs \
    python3-dev \
    wget \
    libstdc++ \
    postgresql-dev
RUN apk --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --update add leveldb leveldb-dev
RUN update-ca-certificates

WORKDIR /app

# Add requirements files before to avoid rebuilding dependencies
# every time any file is modified.
ADD package.json .
ADD package-lock.json .
RUN npm install

# ADD eu-structural-funds/requirements.txt eu-structural-funds/requirements.txt
# RUN pip3 install -r eu-structural-funds/requirements.txt

ADD requirements.txt .
RUN pip3 install -r requirements.txt

ADD . .

ENV PATH "$PATH:/app/node_modules/.bin"

EXPOSE 5000

CMD /app/initialize.sh

