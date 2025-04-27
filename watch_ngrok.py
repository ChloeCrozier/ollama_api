import os
import requests
import time
import re
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

WEBHOOK_URL = os.getenv("DISCORD_WEBHOOK_URL")
NGROK_LOG_FILE = "logs/ngrok.log"

last_url = None  # no URL at first

def find_public_url():
    try:
        with open(NGROK_LOG_FILE, "r") as f:
            content = f.read()
        urls = re.findall(r"https://[a-zA-Z0-9\-]+\.ngrok-free\.app", content)
        if urls:
            return urls[-1]  # Return the latest URL found
    except FileNotFoundError:
        return None
    except Exception as e:
        print(f"Error reading log: {e}")
    return None

def send_discord_message(url):
    data = {
        "content": f"🚀 New ngrok URL: {url}"
    }
    try:
        response = requests.post(WEBHOOK_URL, json=data)
        if response.status_code == 204:
            print(f"✅ Sent new URL to Discord: {url}")
        else:
            print(f"⚠️ Discord returned status {response.status_code}: {response.text}")
    except Exception as e:
        print(f"Error sending to Discord: {e}")

def main():
    global last_url
    print("👀 Watching ngrok.log for new URLs...")
    print(f"Loaded Discord webhook: {WEBHOOK_URL}")
    while True:
        url = find_public_url()
        if url:
            print(f"🔎 Detected URL: {url}")
        else:
            print("❓ No URL detected yet.")

        # Send a Discord message if it's the first URL OR if it changes
        if url and url != last_url:
            print(f"📬 New or changed URL detected! Sending to Discord...")
            send_discord_message(url)
            last_url = url
        time.sleep(30)

if __name__ == "__main__":
    main()
