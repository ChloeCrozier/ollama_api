curl -X POST "https://8e5c-2620-103-a000-ca01-868f-69ff-fef5-1c02.ngrok-free.app/infer" \
-H "Content-Type: application/json" \
-d "{\"model\": \"mistral-nemo:12b\", \"prompt\": \"Tell me a fun fact about space.\"}"
