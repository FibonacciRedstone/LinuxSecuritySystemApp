from gpiozero import MotionSensor
import smtplib
import time

#Motion Sensor at GPIO PIN 4
motion = MotionSensor(4)

def sendMessage(message):
		
        senderEmail = "#######@gmail.com"
        senderPassword = "##########"
        recipientPhone = "##########"

		server = smtplib.SMTP('smtp.gmail.com', 587)
		server.starttls()
		server.login(senderEmail, senderPassword)
		server.sendmail(senderEmail, recipientPhone + "@vtext.com", message)
		server.quit()
def getMillis():
	millis = time.time() * 1000
	return millis	

lastTime = 0
cooldownTimeSeconds = 30
while True:
	try:
		if motion.motion_detected:
			currentTime = getMillis()
			if (currentTime - lastTime) > (cooldownTimeSeconds * 1000):
				now = time.strftime("%c")
				sendMessage("Someone is in your room...")
				print("Sensed")
				lastTime = getMillis()
                #saveFileName
				f = open("securitySave.txt", "w")
				f.write(now + "\n")
				f.close()
	except KeyboardInterrupt:
		print("\rQuitting Security System...")
		quit()
