CC=mpicc

LDFLAGS+=-L$(SDKSTAGE)/opt/vc/lib/ -lGLESv2 -lGLEW -lEGL -lopenmaxil -lbcm_host -lvcos -lvchiq_arm -lpthread -lrt -L../libs/ilclient -L../libs/vgfont -lfreetype
INCLUDES+=-I$(SDKSTAGE)/opt/vc/include/ -I$(SDKSTAGE)/opt/vc/include/interface/vcos/pthreads -I$(SDKSTAGE)/opt/vc/include/interface/vmcs_host/linux -I./ -I../libs/ilclient -I../libs/vgfont -I/usr/include/freetype2 -I./blink1
CFLAGS= -DRASPI -mfloat-abi=hard -mfpu=vfp -O3 -lm -ffast-math -g

all: ogl_utils.o egl_utils.o dividers_gl.o
	mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) ogl_utils.o egl_utils.o dividers_gl.o liquid_gl.c exit_menu_gl.c image_gl.c cursor_gl.c rectangle_gl.c lodepng.c background_gl.c font_gl.c particles_gl.c mover_gl.c controls.c renderer.c geometry.c hash.c communication.c fluid.c -o bin/sph.out

ogl_utils.o: ogl_utils.c ogl_utils.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c ogl_utils.c -o ogl_utils.o

egl_utils.o: egl_utils.c egl_utils.h bcm_host.h renderer.h controls.h
	$(CC) $(CFLAGS) $(INCLUDES) -c egl_utils.c -o egl_utils.o

dividers_gl.o: dividers_gl.c dividers_gl.h glfw_utils.h egl_utils.h
	$(CC) $(CFLAGS) $(INCLUDES) -c dividers_gl.c -o dividers_gl.o

pwmlight:
	mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -DPWMLIGHT -lwiringPi -lcrypt -lwiringPiDev ogl_utils.c egl_utils.c dividers_gl.c liquid_gl.c exit_menu_gl.c image_gl.c cursor_gl.c rectangle_gl.c lodepng.c background_gl.c font_gl.c particles_gl.c mover_gl.c controls.c renderer.c geometry.c hash.c communication.c pwm_light.c fluid.c -o bin/sph.out

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

run: copy
	cd $(HOME) ; mpirun -f ~/pi_mpihostsfile -n 9 ~/sph.out ; cd $(HOME)/SPH


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
