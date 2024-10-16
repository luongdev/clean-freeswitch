To run with default options:
```bash
docker run -d --rm --name switch freeswitch freeswitch 
```
To jump in to a running container with a freeswitch console:
```bash
docker exec -ti switch fs_cli -p Default#Switch@6699
```
> Note: you can also jump into the container with `bash` instead of `fs_cli` to get to a shell prompt in the container.

This container supports the ability to configure the various ports Freeswitch claims, in order to easily run multiple Freeswitch containers on the same host
* --sip-port the sip port to listen on (default: 5080)
* --tls-port the tls port to listen on (default: 5081)
* --event-socket-port the port that Freeswitch event socket listens on (default: 8021)
* --password the event socket password (default: ClueCon)
* --rtp-range-start the starting UDP port for RTP traffic
* --rtp-range-end the ending UDP port for RTP traffic

An example of starting a container with advanced options:
```bash
docker run -d --rm --name switch --net=host \
-v /home/deploy/log:/usr/local/freeswitch/log  \
-v /home/deploy/sounds:/usr/local/freeswitch/sounds \
-v /home/deploy/recordings:/usr/local/freeswitch/recordings \
freeswitch freeswitch --sip-port 5038 --tls-port 5039 --rtp-range-start 20000 --rtp-range-end 21000
```
### OR

```bash
docker run -d --rm --name FS1 --net=host --cap-add=SYS_NICE freeswitch freeswitch \
  --sip-port 5080 --tls-port 5081 --rtp-range-start 31000 --rtp-range-end 32000 \
  --advertise-external-ip --ext-sip-ip 35.247.154.244 --ext-rtp-ip 35.247.154.244
```

### modules.conf.xml
This is the modules.conf.xml file in the image which dictates which modules get loaded.

# Build image locally

Docker build command does not natively support reading variable from `.env` file. Use the following command to build the docker image locally

```bash
sh build-locally.sh
```
