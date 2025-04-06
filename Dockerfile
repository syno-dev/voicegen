FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    ffmpeg \
    libsndfile1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    python3-dev \
    unzip \
    curl \
    && apt-get clean

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN pip install --upgrade pip

RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu

RUN pip install --no-cache-dir sudachipy==0.6.7 --prefer-binary

RUN pip install --no-cache-dir TTS soundfile

WORKDIR /app
COPY clone_voice.py /app/clone_voice.py

CMD ["python", "clone_voice.py"]

