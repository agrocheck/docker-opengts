# OpenGTS


## Build

```
docker build -t agrocheck/opengts:latest src
docker login
docker push agrocheck/opengts:latest
docker logout
```


## Execution

```
docker run \
  -d \
  -p 80:8080 \
  -p 31275:31275 \
  -p 31275:31275/udp \
  --name opengts \
  --restart always \
  agrocheck/opengts:latest \
  start
```
