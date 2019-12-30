import board
import neopixel

class Colors:
    BLACK = (0,0,0)
    RED = (255, 0, 0)
    YELLOW = (255, 150, 0)
    GREEN = (0, 255, 0)
    CYAN = (0, 255, 255)
    BLUE = (0, 0, 255)
    PURPLE = (180, 0, 255)
    COLDWHITE = (255,255,200)
    WARMWHITE = (255,200,70)
    CANDLELIGHT = (255,150,40)
    ORANGE = (255,40,0)

    def hex2rgb(value):
        value = value.lstrip('#')
        lv = len(value)
        return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))
    
    def wheel(pos):
    # Input a value 0 to 255 to get a color value.
    # The colours are a transition r - g - b - back to r.
        if pos < 1:
            return (Colors.WARMWHITE)
        if pos < 85:
            return (255 - pos * 3, pos * 3, 0)
        if pos < 170:
            pos -= 85
            return (0, 255 - pos * 3, pos * 3)
        pos -= 170
        return (pos * 3, 0, 255 - pos * 3)

class Ring:
    global pixels
    global num_pixels

    def __init__(self,num_pixels):
        Ring.num_pixels = num_pixels
        Ring.pixels = neopixel.NeoPixel(board.D0, num_pixels, brightness=0.3, auto_write=False)

    def fill(self,color):
        Ring.pixels.fill(color)
        Ring.pixels.show()
    
    def blend_colors(self,color1,color2):
        for i in range(Ring.num_pixels):
            if i % 2 == 0:
                Ring.pixels[i] = color1
            else:
                Ring.pixels[i] = color2
        Ring.pixels.show()


    def split_colors(self,color1,color2, start = 0):
        for i in range(Ring.num_pixels):
            n = (i + start) % Ring.num_pixels
            if i < Ring.num_pixels/2:
                Ring.pixels[n] = color1
            else:
                Ring.pixels[n] = color2
        Ring.pixels.show()

    def set_brightness(self,brightness):
        Ring.pixels.brightness = brightness
        Ring.pixels.show()