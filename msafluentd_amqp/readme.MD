1. docker run 할 경우 디펄트 로그드라이버 지정

~/.docker/daemon.json

{
"debug": true
,"experimental": true
,"log-driver": "syslog"
,"log-opts": {
		"syslog-address": "tcp://172.17.0.1:514"
		,"tag": "{{.Name}}"
		,"labels": "{{.FullID}}"
		,"env": "{{.ImageName}}"
	}
}

2. docker run시 수동으로 로그드라이버 임의 지정
 --log-driver=fluentd --log-opt fluentd-address=tcp://localhost:24224 \