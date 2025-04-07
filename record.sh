#!/bin/bash

DURATION=10    # recording duration in seconds
RATE=16000     # 16 kHz sample rate
CHANNELS=1     # mono audio

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT="sample_${TIMESTAMP}.wav"

echo "🎙️ Detecting operating system..."

OS="$(uname)"

if [ "$OS" == "Darwin" ]; then
    # macOS - use AVFoundation
    echo "🧠 macOS detected. Using AVFoundation (default mic)."
    INPUT_DEVICE=":1"
    FFMPEG_INPUT="-f avfoundation -i ${INPUT_DEVICE}"
elif [ "$OS" == "Linux" ]; then
    # Linux - try ALSA first
    if command -v arecord >/dev/null 2>&1; then
        echo "🧠 Linux detected. Using ALSA (default mic)."
        FFMPEG_INPUT="-f alsa -i default"
    elif command -v pactl >/dev/null 2>&1; then
        echo "🧠 Linux detected. Using PulseAudio (default mic)."
        FFMPEG_INPUT="-f pulse -i default"
    else
        echo "❌ No supported audio input system found (ALSA or PulseAudio required)."
        exit 1
    fi
else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

echo "🎙️ Recording microphone sample (duration: ${DURATION}s) in 1s..."
sleep 1

ffmpeg $FFMPEG_INPUT -ac $CHANNELS -ar $RATE -t $DURATION "$OUTPUT"

if [ $? -ne 0 ]; then
    echo "❌ Recording failed."
    exit 1
fi

echo "✅ Saved as $OUTPUT"

cp "$OUTPUT" sample.wav

echo "📎 Copied to sample.wav for the model"

exit 0
