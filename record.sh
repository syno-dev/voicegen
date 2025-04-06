#!/bin/bash

DURATION=10  # czas nagrania w sekundach
RATE=16000   # 16 kHz
CHANNELS=1   # mono

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT="sample_${TIMESTAMP}.wav"

echo "🎙️ Nagrywanie próbki z mikrofonu (czas: ${DURATION}s) za 1s..."

sleep 1

ffmpeg -f avfoundation -i ":0" -ac $CHANNELS -ar $RATE -t $DURATION "$OUTPUT"

echo "✅ Zapisano jako $OUTPUT"

cp "$OUTPUT" sample.wav

echo "Skopiowano jako sample.wav dla modelu"

exit 0

