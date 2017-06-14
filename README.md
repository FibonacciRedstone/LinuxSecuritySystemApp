# LinuxSecuritySystemApp
An iOS app for communicating with a custom security system based in Linux

As a pet project, I decided to create a security system on my Raspberry Pi using a motion sensor and a camera.
With the motion sensor I was able to create a python program(`motionSensor.py`) that senses a person and sends a text to my phone number once detected. After this I decided that using ssh to start a screen session and run my program whenever I wanted to start the system was inefficent. This was the motivation for this app.
By modifying the constants `screenSessionName`, `saveFileName`, `sensorFile`,`useCamera` and `commonDirectoryPath`, you can use this app to connect to your own personal security system (Based in linux of course).

While not having the camera to personally implement it in my case, the app is fully extensible for any user who does happen to have a camera connected.

Within this project is also my personal program of which this app is designed to work with (`motionSensor.py`)
All installation instructions that follow are specific to a Raspberry Pi and are assuming that all sensors and cameras are already adequately installed. If different, adjust accordingly.

>Note: All constants are located in the app's `AppDelegate` file.

**To Install Without Camera-**
  1. Download project.
  2. Place configured sensor program into Security System Computer (SSC).
  3. Port forward SSC on port 22.
  4. Configure `screenSessionName` constant to specific name (if different).
  5. Configure `saveFileName` constant to specific file name (if different).
  6. Configure `sensorFile` constant to specific python program name (if different).
  7. Change `useCamera` constant to `false`.
  8. Set `commonDirectoryPath` constant to the path that contains both the saveFile and sensorProgram (if different).
  9. Log in to server via app.
  
**To Install With Camera**
  1. Follow previous steps. 
  2. Change `useCamera` constant to `true`.
  3. Make sure that your program outputs photos to the commonDirectory and outputs the photo name to the saveFile.
