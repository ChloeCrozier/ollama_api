from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import requests

app = FastAPI()

OLLAMA_SERVER_URL = "http://localhost:11434"

class InferenceRequest(BaseModel):
    model: str
    prompt: str

@app.post("/infer")
async def run_inference(request: InferenceRequest):
    payload = {
        "model": request.model,
        "prompt": request.prompt,
        "stream": False   # <- IMPORTANT
    }

    try:
        response = requests.post(f"{OLLAMA_SERVER_URL}/api/generate", json=payload)
        response.raise_for_status()
        data = response.json()
        return {"response": data.get("response", "")}
    except requests.exceptions.HTTPError as e:
        raise HTTPException(status_code=response.status_code, detail=f"Ollama error: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")
