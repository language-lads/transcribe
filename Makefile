# Check if a .env file exists, and then load it
ifneq (,$(wildcard ../.env))
    include ../.env
    export
endif

.PHONY: build start stop enter test-transcription

build:
	docker pull fedirz/faster-whisper-server:latest-cpu
	docker build --tag faster_whisper .

start: stop build guard-TRANSCRIBE_SERVICE_DEV_PORT
	docker run \
		--env PORT=${TRANSCRIBE_SERVICE_DEV_PORT} \
		--publish ${TRANSCRIBE_SERVICE_DEV_PORT}:${TRANSCRIBE_SERVICE_DEV_PORT} \
		--name faster_whisper_server \
		--volume ~/.cache/huggingface:/root/.cache/huggingface \
		faster_whisper

stop:
	docker rm --force faster_whisper_server

enter: stop build
	docker run --rm -it --entrypoint bash faster_whisper

publish: build
	git push dokku main

# Guard to fail the make target if the specified env variable doesn't exist
# https://lithic.tech/blog/2020-05/makefile-wildcards
guard-%:
	@if [ -z '${${*}}' ]; then echo 'ERROR: variable $* not set' && exit 1; fi

test-transcribe-dev:
	curl http://${TRANSCRIBE_SERVICE_DEV_HOST}:${TRANSCRIBE_SERVICE_DEV_PORT}/v1/audio/transcriptions \
		-F "file=@come-ti-chiami.wav" \
		-F "model=Systran/faster-whisper-tiny" \
		-F "language=it"

test-transcribe-prod:
	curl "${TRANSCRIBE_SERVICE_RELEASE_URL}/v1/audio/transcriptions" \
		-F "file=@come-ti-chiami.wav" \
		-F "model=Systran/faster-whisper-tiny" \
		-F "language=it"
