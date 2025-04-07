from TTS.api import TTS
import os

reference_audio = "sample.wav"
default_text = "Hello, this is the default text."

text_file = "text.txt"
if os.path.exists(text_file):
    with open(text_file, "r", encoding="utf-8") as f:
        text = f.read().strip()
    if not text:
        text = default_text
else:
    text = default_text

tts = TTS(model_name="tts_models/multilingual/multi-dataset/your_tts", progress_bar=False, gpu=False)

tts.tts_to_file(
    text=text,
    speaker_wav=reference_audio,
    language="en",
    file_path="output.wav"
)
