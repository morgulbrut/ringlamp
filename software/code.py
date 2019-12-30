from ring import Ring, Colors
import time
import digitalio
import board
import analogio


def ready():
    r.set_brightness(0.1)
    r.fill(Colors.GREEN)
    time.sleep(.5)
    r.fill(Colors.hex2rgb('#ffaa00'))
    time.sleep(.5)
    r.split_colors(Colors.BLUE,Colors.RED)
    time.sleep(1)
    r.blend_colors(Colors.COLDWHITE,Colors.YELLOW)
    time.sleep(1)
    r.fill(Colors.BLACK)


def get_value(pin):
    return (pin.value) / 65536.0



def get_byte_value(pin):
    return int((pin.value * 255) / 65536)


def main():
    mode = 3 # see README.md
    
    mode_sw = digitalio.DigitalInOut(board.D4)
    mode_sw.direction = digitalio.Direction.INPUT
    mode_sw.pull = digitalio.Pull.UP

    pot1 = analogio.AnalogIn(board.D1)
    pot2 = analogio.AnalogIn(board.D2)
    pot3 = analogio.AnalogIn(board.D3)

    while True:
        if not mode_sw.value:
            mode = (mode + 1) % 6
            time.sleep(0.2)
        if mode == 0:
            r.fill(Colors.WARMWHITE)
            r.set_brightness(get_value(pot1)*.7)
        elif mode == 1:
            r.fill(Colors.COLDWHITE)
            r.set_brightness(get_value(pot1)*.7)
        elif mode == 2:
            rval = get_byte_value(pot1)
            gval = get_byte_value(pot2)
            bval = get_byte_value(pot3)
            r.fill((rval,gval,bval))
            r.set_brightness(.7)
        elif mode == 3:
            start = int(get_value(pot2)* 60)
            cols = int(get_value(pot3)* 11)
            if cols == 0:
                r.split_colors(Colors.WARMWHITE,Colors.BLACK, start)
            elif cols == 1:
                r.split_colors(Colors.COLDWHITE,Colors.BLACK, start)
            elif cols == 2:
                r.split_colors(Colors.GREEN,Colors.WARMWHITE, start)
            elif cols == 3:
                r.split_colors(Colors.RED,Colors.WARMWHITE, start)
            elif cols == 4:
                r.split_colors(Colors.BLUE,Colors.WARMWHITE, start)
            elif cols == 5:
                r.split_colors(Colors.RED,Colors.GREEN, start)
            elif cols == 6:
                r.split_colors(Colors.RED,Colors.BLUE, start)
            elif cols == 7:
                r.split_colors(Colors.RED,Colors.YELLOW, start)
            elif cols == 8:
                r.split_colors(Colors.BLUE,Colors.YELLOW, start)
            elif cols == 9:
                r.split_colors(Colors.ORANGE,Colors.GREEN, start)
            else:
                r.split_colors(Colors.BLUE,Colors.BLACK, start)
            r.set_brightness(get_value(pot1)*.7)
        elif mode == 4:
            r.fill(Colors.wheel(get_byte_value(pot2)))
            r.set_brightness(get_value(pot1)*.7)
        elif mode == 5:
            col1 = Colors.wheel(get_byte_value(pot2))
            col2 = Colors.wheel(get_byte_value(pot3))
            r.blend_colors(col1,col2)
            r.set_brightness(get_value(pot1)*.7)
        else:
            r.fill(Colors.BLACK)

if __name__ == '__main__':
    r = Ring(60)
    #ready()
    main()