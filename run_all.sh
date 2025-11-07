#!/bin/bash
cd server && python3 app.py &
flutter run -d web-server --web-port=8080

