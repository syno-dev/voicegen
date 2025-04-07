# Real-Time Voice Cloning with YourTTS

This project allows you to synthesize speech in real time using a short voice sample and any custom text. It uses the [YourTTS](https://github.com/coqui-ai/TTS) multilingual model from the Coqui TTS framework.

## Features

- Clone a voice from a reference audio sample (`sample.wav`)
- Supports multilingual synthesis (limited)
- Outputs a synthetic `.wav` file (`output.wav`)
- Runs fully in Docker, no local Python dependencies required

## Supported Languages

The YourTTS model supports the following languages:

- English (`en`)
- French (`fr-fr`)
- Brazilian Portuguese (`pt-br`)

## Requirements

- [Docker](https://www.docker.com/)
- [FFmpeg](https://ffmpeg.org/) (for recording `.wav` files, optional)

## Usage

### 1. Build the Docker image

```bash
make build
```

### 2. Prepare the voice sample

Record a `.wav` file named `sample.wav`. You can do this using provided script:

```bash
record.sh
```

Or use your preferred recording method.

### 3. Provide the text

Edit or create a file named `text.txt` in the project root.  
Write the sentence or paragraph you want to synthesize.

If the file is missing or empty, a default message will be used:
> "Hello, this is the default text."

### 4. Run the synthesizer

```bash
make run
```

### 5. Clean up Docker image

```bash
make clean
```

## Output

- `output.wav` – the synthesized speech based on your sample and input text
