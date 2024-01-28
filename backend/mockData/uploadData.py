from google.cloud import firestore
import json
import os

# Set the environment variable to point to the local emulator
os.environ["FIRESTORE_EMULATOR_HOST"] = "localhost:8080"  # Use the appropriate port if it's different


# Initialize Firestore client
db = firestore.Client()

with open('/Users/arushirai/Desktop/sheinnovates/backend/mockData/reportData.json', 'r') as f:
    mock_data = json.load(f)
    print(mock_data[0])

# # Define your mock data
# mock_data = [
#     {"name": "John", "age": 30},
#     {"name": "Alice", "age": 25},
#     {"name": "Bob", "age": 35},
# ]

# Upload mock data to Firestore

for i, quiz_result in enumerate(mock_data):
    # Create a reference to a new document with an auto-generated ID
    quiz_result['user']="schmidt_our_one_and_only_user"
    doc_ref = db.collection("quiz_results").add(quiz_result)
    print(i, f"Added document with ID: {doc_ref}")
