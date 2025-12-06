# dev_ws
This is my ros2 project development workspace

## Get all setted up!

First of all in order to avoid conflicts from machine to machine I have managed a dockerfile. This will simplify a lot all the development part!

Open you `build.sh` file and configure the fields as you see fit. If you make any changes please be aware that you have to riflect them in the `run.sh` file as well. If you want you may also add in the `source.repos` the repo you want on your ros2 source folder.

Build your local image!
```bash
bash build.sh
```

Run your container!
```bash
bash run.sh
```

These two steps will create a ros2 source folder in the docker image and the source folder setted up for you.