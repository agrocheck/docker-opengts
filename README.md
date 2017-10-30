# OpenGTS


## Build

```
docker build -t agrocheck/opengts:latest src
docker push agrocheck/opengts:latest
```


## Execution

```
docker run -d -p 8080:8080 -p 31275:31275 --name opengts agrocheck/opengts start
```
