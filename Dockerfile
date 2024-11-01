FROM fedirz/faster-whisper-server:latest-cpu

ENV ENABLE_UI=false

# Override the CMD to ensure it uses the new port
CMD ["sh", "-c", "uv run uvicorn --factory faster_whisper_server.main:create_app --port $PORT"]
