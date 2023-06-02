from playsound import playsound
import simpleaudio as sa

a = 4
arr = "1"
lines = 0

while a < 5:

    #with open('sound.txt') as f:
    #lines = f.readlines()

    # Open a file
    f = open("sound.txt", "r")
    #print(f.read(1))

    #print(lines)

    lines = f.read(1)


    if(lines == arr):
        # for playing wav file
        #playsound('sound.mp3')
        #print("dfksgeds")

        filename = 'sound.wav'
        wave_obj = sa.WaveObject.from_wave_file(filename)
        play_obj = wave_obj.play()
        play_obj.wait_done()  # Wait until sound has finished playing
        print("suc")
    
    # Close opend file
    f.close()
