CC=mpicc

LDFLAGS+=-L$(SDKSTAGE)/opt/vc/lib/ -lGLESv2 -lGLEW -lEGL -lopenmaxil -lbcm_host -lvcos -lvchiq_arm -lrt -L../libs/ilclient -L../libs/vgfont -lfreetype
INCLUDES+=-I$(SDKSTAGE)/opt/vc/include/ -I$(SDKSTAGE)/opt/vc/include/interface/vcos/pthreads -I$(SDKSTAGE)/opt/vc/include/interface/vmcs_host/linux -I./ -I../libs/ilclient -I../libs/vgfont -I/usr/include/freetype2 -I./blink1
CFLAGS= -DRASPI -mfloat-abi=hard -mfpu=vfp -O3 -lm -ffast-math -g

all: ogl_utils.o egl_utils.o dividers_gl.o liquid_gl.o exit_menu_gl.o image_gl.o cursor_gl.o rectangle_gl.o lodepng.o background_gl.o font_gl.o particles_gl.o mover_gl.o controls.o renderer.o geometry.o hash.o communication.o fluid.o
	
	mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) ogl_utils.o egl_utils.o dividers_gl.o liquid_gl.o exit_menu_gl.o image_gl.o cursor_gl.o rectangle_gl.o lodepng.o background_gl.o font_gl.o particles_gl.o mover_gl.o controls.o renderer.o geometry.o hash.o communication.o fluid.o -o bin/sph.out

ogl_utils.o: ogl_utils.c ogl_utils.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c ogl_utils.c -o ogl_utils.o

egl_utils.o: egl_utils.c egl_utils.h renderer.h controls.h
	$(CC) $(CFLAGS) $(INCLUDES) -c egl_utils.c -o egl_utils.o

dividers_gl.o: dividers_gl.c dividers_gl.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c dividers_gl.c -o dividers_gl.o

liquid_gl.o: liquid_gl.c liquid_gl.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c liquid_gl.c -o liquid_gl.o

exit_menu_gl.o: exit_menu_gl.c exit_menu_gl.h cursor_gl.h image_gl.h rectangle_gl.h
	$(CC) $(CFLAGS) $(INCLUDES) -c exit_menu_gl.c -o exit_menu_gl.o

image_gl.o: image_gl.c image_gl.h cursor_gl.h ogl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c image_gl.c -o image_gl.o

cursor_gl.o: cursor_gl.c cursor_gl.h ogl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c cursor_gl.c -o cursor_gl.o

rectangle_gl.o: rectangle_gl.c rectangle_gl.h egl_utils.h glfw_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c rectangle_gl.c -o rectangle_gl.o

lodepng.o: lodepng.c lodepng.h
	$(CC) $(CFLAGS) $(INCLUDES) -c lodepng.c -o lodepng.o

background_gl.o: background_gl.c background_gl.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c background_gl.c -o background_gl.o

font_gl.o: font_gl.c font_gl.h renderer.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c font_gl.c -o font_gl.o

particles_gl.o: particles_gl.c particles_gl.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c particles_gl.c -o particles_gl.o

mover_gl.o: mover_gl.c mover_gl.h
	$(CC) $(CFLAGS) $(INCLUDES) -c mover_gl.c -o mover_gl.o

controls.o: controls.c controls.h
	$(CC) $(CFLAGS) $(INCLUDES) -c controls.c -o controls.o

renderer.o: renderer.c renderer.h
	$(CC) $(CFLAGS) $(INCLUDES) -c renderer.c -o renderer.o

geometry.o: geometry.c geometry.h
	$(CC) $(CFLAGS) $(INCLUDES) -c geometry.c -o geometry.o

hash.o: hash.c hash.h
	$(CC) $(CFLAGS) $(INCLUDES) -c hash.c -o hash.o

communication.o: communication.c communication.h
	$(CC) $(CFLAGS) $(INCLUDES) -c communication.c -o communication.o

fluid.o: fluid.c fluid.h
	$(CC) $(CFLAGS) $(INCLUDES) -c fluid.c -o fluid.o

pwmlight: ogl_utils.o egl_utils.o dividers_gl.o liquid_gl.o exit_menu_gl.o image_gl.o cursor_gl.o rectangle_gl.o lodepng.o background_gl.o font_gl.o particles_gl.o mover_gl.o controls.o geometry.o hash.o communication.o
	mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -DPWMLIGHT -lpthread -lwiringPi -lcrypt -lwiringPiDev ogl_utils.o egl_utils.o dividers_gl.o liquid_gl.o exit_menu_gl.o image_gl.o cursor_gl.o rectangle_gl.o lodepng.o background_gl.o font_gl.o particles_gl.o mover_gl.o controls.o geometry.o hash.o communication.o renderer.c pwm_light.c fluid.c -o bin/sph.out

light:
	mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -DLIGHT ogl_utils.c egl_utils.c rgb_light.c dividers_gl.c liquid_gl.c exit_menu_gl.c image_gl.c cursor_gl.c rectangle_gl.c lodepng.c background_gl.c font_gl.c particles_gl.c mover_gl.c controls.c renderer.c geometry.c hash.c communication.c fluid.c -o bin/sph.out

blink:
	mkdir -p bin
	cd blink1 && make
	mkdir -p bin        
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -DBLINK1 -L./blink1 -lblink1 ogl_utils.c egl_utils.c blink1_light.c dividers_gl.c liquid_gl.c exit_menu_gl.c image_gl.c cursor_gl.c rectangle_gl.c lodepng.c background_gl.c font_gl.c particles_gl.c mover_gl.c controls.c renderer.c geometry.c hash.c communication.c fluid.c -o bin/sph.out

leap:
	mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -DBLINK1 -DLEAP_MOTION_ENABLED1 -L./blink1 -lblink1 -lcurl ogl_utils.c egl_utils.c blink1_light.c dividers_gl.c liquid_gl.c exit_menu_gl.c image_gl.c cursor_gl.c rectangle_gl.c lodepng.c background_gl.c font_gl.c particles_gl.c mover_gl.c controls.c renderer.c geometry.c hash.c communication.c fluid.c -o bin/sph.out

clean:
	rm -f ./bin/sph.out
	rm -f ./*.o
	cd blink1 && make clean

run: copy resetleds saferun

copy:
	rsync ./bin/sph.out chip:~/
	rsync ./bin/sph.out chip2:~/
	rsync ./bin/sph.out chip3:~/
	rsync ./bin/sph.out chip4:~/
	rsync ./bin/sph.out chip5:~/
	rsync ./bin/sph.out chip6:~/
	rsync ./bin/sph.out chip7:~/
	rsync ./bin/sph.out chip8:~/
	rsync ./bin/sph.out chip9:~/

resetleds:
	ssh chip2 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	ssh chip3 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	ssh chip4 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	ssh chip5 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	ssh chip6 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	ssh chip7 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	ssh chip8 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	ssh chip9 "gpio mode 23 in;gpio mode 24 in; gpio mode 25 in"
	gpio mode 23 in
	gpio mode 24 in
	gpio mode 25 in

saferun:
	cd $(HOME) ; mpirun -f ~/pi_mpihostsfile -n 9 ~/sph.out ; cd $(HOME)/SPH
