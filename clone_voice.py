from TTS.api import TTS

reference_audio = "sample.wav"

#text = "To yest test generovanya głosu pszy użytsiu mojego głosu referentsyjnego."
text = "Hello my name is Peter and im still alive"

tts = TTS(model_name="tts_models/multilingual/multi-dataset/your_tts", progress_bar=False, gpu=False)

tts.tts_to_file(
    text=text,
    speaker_wav=reference_audio,
    language="en",
    file_path="output.wav"
)

