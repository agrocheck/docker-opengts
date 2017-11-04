# OpenGTS


## Build

```
docker build -t agrocheck/opengts:latest src
docker push agrocheck/opengts:latest
```


## Execution

```
docker run -d -p 80:8080 -p 31275:31275 -p 31275:31275/udp --name opengts agrocheck/opengts:latest start
```
