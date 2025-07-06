
API Testing link of postman 

https://shreya-4669070.postman.co/workspace/shreya's-Workspace~6960334e-da4a-4f2b-89bf-0f3c6c0f7f2f/collection/46287483-22a07dd4-6220-4188-bc58-53528cca8fda?action=share&source=copy-link&creator=46287483


Profile setup
https://github.com/user-attachments/assets/1af2afc0-272b-4e9f-aef2-45e58db401dc


Settings
![Screenshot 2025-07-06 153116](https://github.com/user-attachments/assets/025032ae-fff4-4af7-9fe9-053673922d40)
https://github.com/user-attachments/assets/fe379697-8f26-41ae-a23d-b50fc34711eb


Notification page
![Screenshot 2025-07-06 153309](https://github.com/user-attachments/assets/26499177-ffb5-4192-b02b-09a266a4a1fb)


# Smart Roomie
## Overview
Mobile app for finding trustworthy, lifestyle-compatible roommates in NYC using LLM and sensors.

## AI Strategy
- Conversational onboarding: /api/onboarding extracts preferences in <5 min.
- Semantic matching: /api/matches provides explainable AI reasons.
- Agreements: /api/agreements generates AI-drafted agreements.
- Mediation: /api/mediation analyzes chat sentiment.

## Sensor Usage
- Camera/LiDAR: Room dimensions (mocked, planned: flutter_arkit, ar_core).
- Microphone: Noise level (mocked, planned: mic_stream).
- Ambient Light: Light level (mocked, planned: sensors_plus).
- Biometrics: Identity verification (local_auth).
- Bluetooth LE: Presence detection (mocked, planned: flutter_reactive_ble).

## Privacy
- Local audio/video processing.
- Granular permissions with permission_handler.

## Accessibility
- WCAG 2.2-AA: Semantics, keyboard navigation, high-contrast colors.

## Validation
- Time to first match: ≤5 min.
- Trust score: ≥80%.
- Fraud reduction: ≥70%.
- SUS: ≥80.

## Setup
1. Backend: `cd backend && npm install && npm start`
2. Frontend: `cd frontend && flutter run`
3. Test APIs: Import `smart-roomie-api.postman_collection.json` into Postman.
