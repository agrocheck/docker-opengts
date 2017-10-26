# OpenGTS


## Build

```
docker build -t agrogts/opengts src
```


## Execution

```
docker run -d -p 8080:8080 -p 10000:10000 --name opengts agrogts/opengts start
```
