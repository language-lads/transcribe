# Transcribe

This runs (`faster-whisper-server`)[https://github.com/fedirz/faster-whisper-server] as a transcription service on the server.

It's supposed to be fully compatible with the OpenAI API so should be able to switch in and out of easily.

Uses `Systran/faster-whisper-tiny` for speed and efficiency.

On my Mac M1 Pro, using `Systran/faster-whisper-small` still takes up to 3 seconds to transcribe a very brief audio file. Little bit too slow for my taste and since it's only used to feed LLM conversation history it doesn't have to be 100% perfect. We'll go with `tiny` and we can rely on the LLM to pick out the correct meaning from any transcription errors.

## Dokku setup

```bash

ssh -t tbone@<server> dokku apps:create transcribe
git remote add dokku dokku@<server>:transcribe
dokku letsencrypt:enable
git push dokku main
```
