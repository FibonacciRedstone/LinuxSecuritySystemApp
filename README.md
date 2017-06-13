# LinuxSecuritySystemApp
An iOS app for communicating with a custom security system based in linux

As a pet project, I decided to create a security system on my Raspberry Pi using a motion sensor and a camera.
Despite not having a camera, I successfully created a python program(`motionSensor.py`) that senses a person
and sends a text to my phone number once detected. After this I decided that using ssh to start a screen session and run my program whenever I wanted to start the system was inefficent. This was the motivation for this app.
By modifying the constants `screenSessionName`, `saveFileName`, `sensorFile`,`useCamera` and `commonDirectoryPath`, you can use this app to connect to your own personal security system (Based in linux of course).

