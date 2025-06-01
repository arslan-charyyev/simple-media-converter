# We use latest ubuntu LTS image because we need latest ffmpeg
FROM ubuntu:25.04

# install system wide dependencies
RUN  \
  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  && apt-get update \
  && apt-get -y --no-install-recommends install \
  python3 python3-pip python3-venv python3-dev \
  ffmpeg libheif-dev build-essential

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# set a directory for the app
WORKDIR /usr/src/app

# install app-specific dependencies
COPY requirements.txt ./
RUN --mount=target=/root/.cache/pip,type=cache,sharing=locked \
  pip install -r requirements.txt

# copy all the files to the container
COPY . .
RUN mkdir ./input_media ./output_media

# app command
CMD ["python", "-u", "./main.py"]
