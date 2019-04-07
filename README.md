# Devops 사전과제 구현내용 (지원자 : 나정호)


## 1. Gradle build
- 다음의 명령어로 gradle을 통해 spring-boot-sample-web-ui Application을 build하고 WAR를 생성한다.
- 여기서 Argument로 작성되는 version은 WAR 버전이다. (최초 v1로 작성)
```bash
$ gradle-build.sh v1
```


## 2. Docker build

### 1) Nginx docker build
- 다음의 명령어로 docker를 통해 Nginx Web Server을 Container화 한다.
```bash
$ docker-nginx-build.sh
```

### 2) Web UI Application docker build
- 다음의 명령어로 docker를 통해 spring-boot-sample-web-ui Application을 Container화 한다.
- 여기서 Argument로 작성되는 version은 Container 버전이다. (최초 v1로 작성)
```bash
$ docker-web-ui-build.sh v1
```


## 3. Docker swarm 실행
- 다음의 명령어로 Docker swarm을 실행하고 Node를 생성한다.

```bash
$ docker swarm init
```


## 4. 실행 스크립트(devops.sh) 기능 

- 다음의 명령어로 배포를 위한 환경실행(시작), 중지, 재시작, 배포를 수행 할 수 있다.
```bash
$ devops.sh [start | stop | restart | deploy]
```
- start : 컨테이너 환경 전체 실행
- stop : 컨테이너 환경 전체 중지
- restart : 컨테이너 환경 전체 재시작
- deploy : 웹어플리케이션 무중단 배포

### 1) 배포환경 실행(시작)
- 다음의 명령어로 컨테이너 환경을 전체 실행(시작)한다. 
```bash
$ devops.sh start
```

### 2) 배포환경 중지
- 다음의 명령어로 컨테이너 환경을 전체 중지한다.
```bash
$ devops.sh stop
```

### 3) 배포환경 재시작
- 다음의 명령어로 컨테이너 환경을 전체 재시작한다.
```bash
$ devops.sh restart
```

### 4) 웹어플리케이션 무중단 배포
- 아래에 명시된 6번항목 참조 


## 5. 실행 스크립트(devops.sh) 배포환경 실행(시작) 검증

### 1) 배포상태 확인
- 다음의 명령어로 배포가 된 후의 상태를 확인한다.
```bash
$ docker stack services spring-boot
```
- Health check는 다음과 같이 확인한다.
```bash
$ curl http://localhost/health
```
- 정상일 경우 JSON형태( {"status":"UP"} )로 Health check값이 표시된다.

### 2) Web UI Application 실행 확인
- Web Browser에서 다음과 같은 URL로 접속한다.
```bash
http://localhost
```


## 6. 실행 스크립트(devops.sh) 기능 - 웹어플리케이션 무중단 배포

### 1) Gradle build
- 다음의 명령어로 gradle을 통해 spring-boot-sample-web-ui Application을 build하고 WAR를 생성한다.
- 여기서 Argument로 작성되는 version은 WAR 버전이다.
- sprint-boot-sample-web-ui를 수정했다는 가정아래 WAR 버전을 업데이트 한다. (v1 -> v2)
```bash
$ gradle-build.sh v2
```

### 2) Web UI Application docker build
- 다음의 명령어로 docker를 통해 spring-boot-sample-web-ui Application을 Container화 한다.
- 여기서 Argument로 작성되는 version은 Container 버전이다.
- WAR 버전이 업데이트 됨에 따라 web-ui docker image 버전도 업데이트한다. (v1 -> v2)
```bash
$ docker-web-ui-build.sh v2
```

### 3) 웹어플리케이션 무중단 배포
- web-ui v1(버전1)으로 배포한 application을 web-ui v2(버전2)로 무중단 배포한다.
- Blue-Green 방식으로 배포를 한다.
```bash
$ devops.sh deploy
```

### 4) Application 버전변경 모니터링
- watch 명령어를 통해 Application 버전변경에 대한 모니터링을 수행한다.
```bash
$ watch "docker ps"
```