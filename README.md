# docker-bengine
A repo for building a docker image that runs Bengine

#### Build only the Bengine image
You can build the image by itself by running the build.sh script.

#### Compose the Bengine & block images
You can use docker-compose to build, link, & run the Bengine image along with other block images. To do so, you must edit **compose-qengine/docker-compose.yml**

```
cd compose-bengine
bash compose.sh
```
