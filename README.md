# daleks-docker

1. 拉取 `daleks-docker`
```bash
git clone https://github.com/0x7a66/daleks-docker
```

2. 进入 `daleks-docker` 目录
```bash
cd daleks-docker
```

3. 运行
```bash
docker compose up -d
```
>老版本或 MAC 系统上可能需要执行 `docker-compose up -d`

4. 查看启动日志
```bash
docker logs daleks
```

若日志出现 `risk server started...` 表示启动成功。

浏览器打开 `http://localhost:8080/` 即可进入系统.
