#!/bin/bash

DURATION=10    # recording duration in seconds
RATE=16000     # 16 kHz sample rate
CHANNELS=1     # mono audio

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT="sample_${TIMESTAMP}.wav"

OS="$(uname)"
FFMPEG_INPUT=""

if [ "$OS" == "Darwin" ]; then
    echo "🧠 macOS detected."

    if ffmpeg -f avfoundation -list_devices true -i "" 2>&1 | grep -q '\[0\] Microsoft Teams Audio'; then
        echo "❗ [0] is Microsoft Teams Audio → using :1"
        DEVICE_INDEX=1
    else
        DEVICE_INDEX=0
    fi

    FFMPEG_INPUT="-f avfoundation -i :$DEVICE_INDEX"

elif [ "$OS" == "Linux" ]; then
    echo "🧠 Linux detected."
    if command -v arecord >/dev/null 2>&1; then
        FFMPEG_INPUT="-f alsa -i default"
    elif command -v pactl >/dev/null 2>&1; then
        FFMPEG_INPUT="-f pulse -i default"
    else
        echo "❌ No supported Linux audio system found (ALSA or PulseAudio)."
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
