FROM python:3.13.3

# install system wide dependencies
RUN  \
  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  && apt-get update \
  && apt-get -y --no-install-recommends install \
  ffmpeg libheif-dev

# set a directory for the app
WORKDIR /usr/src/app

# install app-specific dependencies
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install --no-cache-dir -r requirements.txt

# copy all the files to the container
COPY . .
RUN mkdir ./input_media ./output_media

# app command
CMD ["python", "-u", "./main.py"]
