IMAGE_NAME=yourtts-cpu
CONTAINER_NAME=yourtts-container
TTS_CACHE=$(HOME)/.cache/tts

.PHONY: build run clean

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --rm \
		--name $(CONTAINER_NAME) \
		-v $(PWD):/app \
		-v $(TTS_CACHE):/root/.local/share/tts \
		$(IMAGE_NAME)

clean:
	docker rmi -f $(IMAGE_NAME)

