from locust import HttpUser, task, between
import random
import string
import uuid
import datetime

# Helper functions for generating random data
def random_string(length=8):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def random_email():
    return f"{random_string(10)}@example.com"

def random_event():
    events = ["testEvent", "userLogin", "itemPurchase", "pageView"]
    return random.choice(events)

def random_properties():
    return {
        "testProp": random_string(15),
        "customProp": random.randint(1, 100)
    }

class LoadTestUser(HttpUser):
    wait_time = between(1, 1)  # Simulate a delay between tasks
    host = "http://localhost:30490"  # Host yang menjadi target

    @task
    def send_track_event(self):
        headers = {
            'Content-Type': 'application/json',
            'X-Write-Key': 'mArqZeADEXhQ4iXypt7QEnXEPoxhmQ9r:MYZ*WL6'
        }
        data = {
            "type": "track",
            "event": random_event(),
            "properties": random_properties(),
            "userId": random_email(),
            "anonymousId": str(uuid.uuid4()),
            "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
            "sentAt": datetime.datetime.utcnow().isoformat() + "Z",
            "messageId": str(uuid.uuid4()),
            "context": {
                "library": {
                    "name": "jitsu-js",
                    "version": "1.0.0"
                },
                "ip": "127.0.0.1",
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/111.0",
                "locale": "en-US",
                "screen": {
                    "width": 2304,
                    "height": 1296,
                    "innerWidth": 1458,
                    "innerHeight": 1186,
                    "density": 2
                },
                "traits": {
                    "email": random_email()
                },
                "page": {
                    "path": "/",
                    "referrer": "",
                    "referring_domain": "",
                    "host": "example.com",
                    "search": "",
                    "title": "Example page event",
                    "url": "https://example.com/",
                    "encoding": "UTF-8"
                },
                "campaign": {
                    "name": "example",
                    "source": "g"
                }
            },
            "receivedAt": datetime.datetime.utcnow().isoformat() + "Z"
        }

        self.client.post("/api/s/s2s/track", headers=headers, json=data)
