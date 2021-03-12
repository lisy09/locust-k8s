FROM python:3.9-slim

RUN apt-get update && DEBIAN_FRONTED=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
   && rm -rf /tmp/pip-tmp

RUN useradd -ms /bin/bash locust
WORKDIR /home/locust
ENTRYPOINT ["locust"]

# turn off python output buffering
ENV PYTHONUNBUFFERED=1