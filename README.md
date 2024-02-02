The Dockerfile in this directory sets up an Ubuntu image ready to build a LineageOS 19.1 branch of Android.

First, build the image:

	# Copy your host gitconfig, or create a stripped down version
	$ cp ~/.gitconfig gitconfig
	$ docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t android-build-19 .

Then you can start up new instances with:

	> export ANDROID_BUILD_TOP=/path/to/your/android/source
	$ docker run -it --rm -v $ANDROID_BUILD_TOP:/src android-build-19
	> cd /src
	> source build/envsetup.sh
	> breakfast <DEVICE_NAME>
	> brunch <DEVICE_NAME>
