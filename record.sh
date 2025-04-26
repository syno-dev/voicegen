#!/bin/bash

# ============================
# README
# ============================
# This script records audio from the microphone using ffmpeg.
# It supports macOS and Linux systems and saves the recording to a specified output file.
#
# Usage:
#   ./record.sh [OPTIONS]
#
# Options:
#   -h, --help            Display this help message and exit.
#   --duration <seconds>  Duration of the recording in seconds (required).
#   --channels <number>   Number of audio channels (default: 1).
#   --rate <rate>         Audio sample rate in Hz (default: 44100).
#   --output <file>       Output file name (default: output.wav).
#
# Example:
#   ./record.sh --duration 10 --channels 2 --rate 48000 --output my_audio.wav
#
# Notes:
#   - On macOS, the script uses the avfoundation input device.
#   - On Linux, the script supports ALSA and PulseAudio.
#   - If the --additional_output flag is provided, the recording is also saved as sample.wav.
# ============================

# Display help message
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    head -n 20 "$0" | tail -n 18
    exit 0
fi

# Default values
DURATION=""
CHANNELS=1
RATE=44100
OUTPUT="output.wav"
ADDITIONAL_OUTPUT=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --duration)
            DURATION="$2"
            shift 2
            ;;
        --channels)
            CHANNELS="$2"
            shift 2
            ;;
        --rate)
            RATE="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --additional_output)
            ADDITIONAL_OUTPUT=true
            shift
            ;;
        *)
            echo "❌ Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$DURATION" ]]; then
    echo "❌ Missing required argument: --duration"
    exit 1
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "❌ ffmpeg is not installed. Please install it first."
    exit 1
fi

# Function to set FFMPEG input for macOS
set_ffmpeg_input_mac() {
    if ffmpeg -f avfoundation -list_devices true -i "" 2>&1 | grep -q '\[0\] Microsoft Teams Audio'; then
        echo "❗ [0] is Microsoft Teams Audio → using :1"
        DEVICE_INDEX=1
    else
        DEVICE_INDEX=0
    fi

    FFMPEG_INPUT="-f avfoundation -i :$DEVICE_INDEX"
}

# Function to set FFMPEG input for Linux
set_ffmpeg_input_linux() {
    if command -v arecord >/dev/null 2>&1; then
        FFMPEG_INPUT="-f alsa -i default"
    elif command -v pactl >/dev/null 2>&1; then
        FFMPEG_INPUT="-f pulse -i default"
    else
        echo "❌ No supported Linux audio system found (ALSA or PulseAudio)."
        exit 1
    fi
}

# Detect OS and set FFMPEG input
case "$(uname)" in
    "Darwin")
        echo "🍎 macOS detected."
        set_ffmpeg_input_mac
        ;;
    "Linux")
        echo "🧠 Linux detected."
        set_ffmpeg_input_linux
        ;;
    *)
        echo "❌ Unsupported OS: $(uname)"
        exit 1
        ;;
esac

# Start recording
echo "🎙️ Recording microphone sample (duration: ${DURATION}s) in 1s..."
sleep 1

ffmpeg -y $FFMPEG_INPUT -ac "$CHANNELS" -ar "$RATE" -t "$DURATION" "$OUTPUT"

# Check if recording succeeded
if [ $? -ne 0 ]; then
    echo "❌ Recording failed."
    exit 1
fi

echo "✅ Saved as $OUTPUT"

exit 0
