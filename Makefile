all: dl \
	SDL2.framework \
	physfs.framework \
	mpg123.framework \
	libmodplug.framework \
	Ogg.framework \
	Vorbis.framework \
	Theora.framework \
	OpenAL-Soft.framework \
	FreeType.framework \
	Lua.framework

dl: SDL2-2.0.14.zip \
	physfs-3.0.2.tar.bz2 \
	mpg123-1.26.4.tar.bz2 \
	libmodplug-0.8.9.0.tar.gz \
	libogg-1.3.4.tar.gz \
	libvorbis-1.3.7.tar.gz \
	libtheora-1.1.1.tar.bz2 \
	openal-soft-1.21.0.tar.bz2 \
	freetype-2.10.4.tar.gz \
	luajit2.uguu

SDL2.framework: SDL2-2.0.14
	pushd SDL2-2.0.14/Xcode/SDL && \
	xcodebuild -target Framework \
		-configuration Release -scheme Framework \
		SYMROOT="../.." && \
	popd && \
	mv SDL2-2.0.14/Release/SDL2.framework . && \
	mv SDL2-2.0.14/Release/hidapi.framework .

SDL2-2.0.14: SDL2-2.0.14.zip
	unzip SDL2-2.0.14.zip && \
	touch SDL2-2.0.14

SDL2-2.0.14.zip:
	wget https://www.libsdl.org/release/SDL2-2.0.14.zip

physfs.framework: physfs-3.0.2
	mkdir -p physfs-3.0.2/build/Release && \
	pushd physfs-3.0.2/build && \
	cmake -G Xcode .. && \
	xcodebuild -target physfs \
		-configuration Release -scheme physfs \
		SYMROOT="./build" && \
	pushd Release && \
	mv libphysfs.3.0.2.dylib physfs && \
	../../../make_framework.sh physfs 3.0.2 org.physfs && \
	cp ../../src/physfs.h physfs.framework/Versions/A/Headers/physfs.h && \
	popd && popd && \
	mv physfs-3.0.2/build/Release/physfs.framework .

physfs-3.0.2: physfs-3.0.2.tar.bz2
	tar xzf physfs-3.0.2.tar.bz2

physfs-3.0.2.tar.bz2:
	wget https://icculus.org/physfs/downloads/physfs-3.0.2.tar.bz2

mpg123.framework: mpg123-1.26.4
	pushd mpg123-1.26.4 && \
	./configure && \
	make src/libmpg123/libmpg123.la && \
	cp ./src/libmpg123/.libs/libmpg123.0.dylib ./mpg123 && \
	../make_framework.sh mpg123 1.26.4 org.mpg123 && \
	cp ./src/libmpg123/mpg123.h mpg123.framework/Versions/A/Headers/mpg123.h && \
	popd && \
	mv mpg123-1.26.4/mpg123.framework .

mpg123-1.26.4: mpg123-1.26.4.tar.bz2
	tar xzf mpg123-1.26.4.tar.bz2

mpg123-1.26.4.tar.bz2:
	wget https://jaist.dl.sourceforge.net/project/mpg123/mpg123/1.26.4/mpg123-1.26.4.tar.bz2

libmodplug.framework: libmodplug-0.8.9.0
	pushd libmodplug-0.8.9.0 && \
	./configure && \
	make && \
	cp ./src/.libs/libmodplug.1.dylib libmodplug && \
	../make_framework.sh libmodplug 0.8.9.0 org.libmodplug && \
	cp ./src/modplug.h libmodplug.framework/Versions/A/Headers/modplug.h && \
	install_name_tool -id "@rpath/libmodplug.framework/Versions/A/libmodplug" libmodplug.framework/libmodplug && \
	popd && \
	mv libmodplug-0.8.9.0/libmodplug.framework .

libmodplug-0.8.9.0: libmodplug-0.8.9.0.tar.gz
	tar xzf libmodplug-0.8.9.0.tar.gz

libmodplug-0.8.9.0.tar.gz:
	wget https://jaist.dl.sourceforge.net/project/modplug-xmms/libmodplug/0.8.9.0/libmodplug-0.8.9.0.tar.gz

Ogg.framework: libogg-1.3.4
	pushd libogg-1.3.4 && \
	cmake -G Xcode -DBUILD_FRAMEWORK=1 && \
	xcodebuild -target ogg \
		-configuration Release -scheme ogg \
		SYMROOT="./build" && \
	popd && \
	mv libogg-1.3.4/build/Release/Ogg.framework .

libogg-1.3.4: libogg-1.3.4.tar.gz
	tar xzf libogg-1.3.4.tar.gz

libogg-1.3.4.tar.gz:
	wget https://downloads.xiph.org/releases/ogg/libogg-1.3.4.tar.gz

Vorbis.framework: libvorbis-1.3.7 Ogg.framework
	pushd libvorbis-1.3.7 && \
	cmake -G Xcode -DBUILD_FRAMEWORK=1 && \
	pushd lib && \
	ln -s ../../Ogg.framework/Headers ogg && \
	popd && \
	xcodebuild -target vorbis \
		-configuration Release -scheme vorbis \
		SYMROOT="./build" \
		HEADER_SEARCH_PATHS="$(shell pwd)/libvorbis-1.3.7/lib" && \
	popd && \
	mv libvorbis-1.3.7/build/Release/Vorbis.framework .

libvorbis-1.3.7: libvorbis-1.3.7.tar.gz
	tar xzf libvorbis-1.3.7.tar.gz

libvorbis-1.3.7.tar.gz:
	wget https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.gz

Theora.framework: libtheora-1.1.1
	pushd libtheora-1.1.1 && \
	./configure && \
	make && \
	cp ./lib/.libs/libtheora.0.dylib ./Theora && \
	../make_framework.sh Theora 1.1.1 org.theora && \
	cp ./include/theora/codec.h Theora.framework/Versions/A/Headers/codec.h && \
	cp ./include/theora/theora.h Theora.framework/Versions/A/Headers/theora.h && \
	cp ./include/theora/theoradec.h Theora.framework/Versions/A/Headers/theoradec.h && \
	cp ./include/theora/theoraenc.h Theora.framework/Versions/A/Headers/theoraenc.h && \
	install_name_tool -id "@rpath/Theora.framework/Versions/A/Theora" Theora.framework/Theora && \
	install_name_tool -change "/opt/homebrew/opt/libogg/lib/libogg.0.dylib" "@rpath/Ogg.framework/Ogg" Theora.framework/Theora && \
	popd && \
	mv libtheora-1.1.1/Theora.framework .

libtheora-1.1.1: libtheora-1.1.1.tar.bz2
	tar xzf libtheora-1.1.1.tar.bz2

libtheora-1.1.1.tar.bz2:
	wget https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2

OpenAL-Soft.framework: openal-soft-1.21.0
	pushd openal-soft-1.21.0 && \
	cmake -G Xcode && \
	xcodebuild -target OpenAL \
		-configuration Release -scheme OpenAL \
		SYMROOT="." && \
	cp Release/libopenal.1.21.0.dylib ./OpenAL-Soft && \
	../make_framework.sh OpenAL-Soft 1.21.0 org.openal && \
	cp ./include/AL/al.h OpenAL-Soft.framework/Versions/A/Headers/al.h && \
	cp ./include/AL/alc.h OpenAL-Soft.framework/Versions/A/Headers/alc.h && \
	cp ./include/AL/alext.h OpenAL-Soft.framework/Versions/A/Headers/alext.h && \
	cp ./include/AL/efx.h OpenAL-Soft.framework/Versions/A/Headers/efx.h && \
	cp ./include/AL/efx-creative.h OpenAL-Soft.framework/Versions/A/Headers/efx-creative.h && \
	cp ./include/AL/efx-presets.h OpenAL-Soft.framework/Versions/A/Headers/efx-presets.h && \
	install_name_tool -id "@rpath/OpenAL-Soft.framework/Versions/A/OpenAL-Soft" OpenAL-Soft.framework/OpenAL-Soft && \
	popd && \
	mv openal-soft-1.21.0/OpenAL-Soft.framework .

openal-soft-1.21.0: openal-soft-1.21.0.tar.bz2
	tar xzf openal-soft-1.21.0.tar.bz2

openal-soft-1.21.0.tar.bz2:
	wget https://www.openal-soft.org/openal-releases/openal-soft-1.21.0.tar.bz2

FreeType.framework: freetype-2.10.4
	pushd freetype-2.10.4 && \
	./configure && \
	make && \
	cp ./objs/.libs/libfreetype.6.dylib ./FreeType && \
	../make_framework.sh FreeType 2.10.4 org.freetype && \
	cp ./include/ft2build.h FreeType.framework/Versions/A/Headers/ft2build.h && \
	install_name_tool -id "@rpath/FreeType.framework/Versions/A/FreeType" FreeType.framework/FreeType && \
	popd && \
	cp ./freetype-2.10.4/include/freetype/*.h freetype-2.10.4/FreeType.framework/Versions/A/Headers && \
	cp -r ./freetype-2.10.4/include/freetype/config freetype-2.10.4/FreeType.framework/Versions/A/Headers && \
	mv freetype-2.10.4/FreeType.framework .

freetype-2.10.4: freetype-2.10.4.tar.gz
	tar xzf freetype-2.10.4.tar.gz

freetype-2.10.4.tar.gz:
	wget https://jaist.dl.sourceforge.net/project/freetype/freetype2/2.10.4/freetype-2.10.4.tar.gz

Lua.framework: luajit2
	pushd luajit2/src && \
	MACOSX_DEPLOYMENT_TARGET=10.9 make libluajit.so && \
	gcc -dynamiclib -single_module -undefined dynamic_lookup -fPIC \
		-install_name @rpath/Lua.framework/Versions/A/Lua \
		-compatibility_version 2.1 -current_version 2.1.0 \
		-o Lua lj_vm.o lj_gc.o lj_err.o lj_char.o lj_bc.o \
		lj_obj.o lj_buf.o lj_str.o lj_tab.o lj_func.o lj_udata.o \
		lj_meta.o lj_debug.o lj_state.o lj_dispatch.o lj_vmevent.o \
		lj_vmmath.o lj_strscan.o lj_strfmt.o lj_strfmt_num.o lj_api.o \
		lj_profile.o lj_lex.o lj_parse.o lj_bcread.o lj_bcwrite.o \
		lj_load.o lj_ir.o lj_opt_mem.o lj_opt_fold.o lj_opt_narrow.o \
		lj_opt_dce.o lj_opt_loop.o lj_opt_split.o lj_opt_sink.o \
		lj_mcode.o lj_snap.o lj_record.o lj_crecord.o lj_ffrecord.o \
		lj_asm.o lj_trace.o lj_gdbjit.o lj_ctype.o lj_cdata.o \
		lj_cconv.o lj_ccall.o lj_ccallback.o lj_carith.o lj_clib.o \
		lj_prng.o \
		lj_cparse.o lj_lib.o lj_alloc.o lib_aux.o lib_base.o \
		lib_math.o lib_bit.o lib_string.o lib_table.o lib_io.o \
		lib_os.o lib_package.o lib_debug.o lib_jit.o lib_ffi.o lib_init.o -lm && \
	../../make_framework.sh Lua 2.1.0-beta3 org.luajit && \
	cp luaconf.h Lua.framework/Headers && \
	cp lua.hpp Lua.framework/Headers && \
	cp lualib.h Lua.framework/Headers && \
	cp luajit.h Lua.framework/Headers && \
	cp lua.h Lua.framework/Headers && \
	cp lauxlib.h Lua.framework/Headers && \
	popd && \
	mv luajit2/src/Lua.framework .

luajit2: luajit2.uguu
	cp -r luajit2.uguu luajit2

luajit2.uguu:
	git clone https://github.com/openresty/luajit2.git luajit2.uguu

.PHONY: clean-local

clean-local:
	rm -rf hidapi.framework \
		SDL2.framework \
		physfs.framework \
		mpg123.framework \
		libmodplug.framework \
		Ogg.framework \
		Vorbis.framework \
		Theora.framework \
		OpenAL-Soft.framework \
		FreeType.framework \
		Lua.framework \
		SDL2-2.0.14 \
		physfs-3.0.2 \
		mpg123-1.26.4 \
		libmodplug-0.8.9.0 \
		libogg-1.3.4 \
		libvorbis-1.3.7 \
		libtheora-1.1.1 \
		openal-soft-1.21.0 \
		freetype-2.10.4 \
		luajit2

.PHONY: clean

clean: clean-local
	rm -rf SDL2-2.0.14.zip \
		physfs-3.0.2.tar.bz2 \
		mpg123-1.26.4.tar.bz2 \
		libmodplug-0.8.9.0.tar.gz \
		libogg-1.3.4.tar.gz \
		libvorbis-1.3.7.tar.gz \
		libtheora-1.1.1.tar.bz2 \
		openal-soft-1.21.0.tar.bz2 \
		freetype-2.10.4.tar.gz \
		luajit2.uguu

.PHONY: install-deps

install-deps:
	brew install wget cmake libtool autoconf make automake libogg