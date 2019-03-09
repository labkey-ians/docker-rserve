Here is the run command I used. I haven't really refined this yet. The jist is that the container user needs to have volume read/write access in the host system using the uid/gid supplied to the run command: 

```
docker run -it -d -p 6311:6311 \
	-v ~/docker/volumes/rserve/data:/volumes/data \
	-v ~/docker/volumes/rserve/reports_temp:/volumes/reports_temp \
	-u 1000:1042 \
	-e USERNAME=rserve -e PASSWORD=rserve \
	--rm \
	--name rserve usgs/rserve
```
The two volumes are the paths needed by the LabKey reports, and are the mappings supplied to the configured engine
The readme below is copied from the original RServe container repo.

Docker RServe
===

Provides a container to allow the user to spring up an RServe service quickly. Based on the [R-Base](https://hub.docker.com/_/r-base/) official community container.

Docker Compose: edit the compose.env file to add your own username and password that rserve will use for authentication. Otherwise, the username and password will be `rserve`. The container can be sprung up by executing `docker-compose up`

If using plain Docker, the simplest way to run is:

`docker run -p 6311:6311 usgs/rserve[:TAG]`

If you wish to use your own username and password:

`docker run  -e USERNAME=<username> -e PASSWORD=<password> -p 6311:6311 usgs/rserve`

The RServe Docker container provides its services on the exposed port `6311`.

There is a [health check](https://docs.docker.com/engine/reference/builder/#/healthcheck) on the container which tests whether RServe is up by attempting to connect to it.
