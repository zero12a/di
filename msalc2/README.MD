
-mac 사용자 인경우

1. 로그기본 드라이버를 지정하고나서  (mac os에서)
 - ~/.docker/daemon.json 파일에 드라이버 아래와 같이 교체

{
"debug": true
,"experimental": true
,"log-driver": "syslog"
,"log-opts": {
		"syslog-address": "tcp://172.17.0.1:514"
		,"tag": "{{.Name}}"
	}
}

2. docker ui툴을에서 "Restart docker"를 실행하고

3. docker run하면 자동으로 로그드라이버가 연결됨
 - 이전에 생성된 run이미지는 삭제하고 재생성해야 연결됨.
 




-------------라이브러리 설치 장소-----------------
/usr/lib/rsyslog# ls
fmhash.so      imklog.so      impstats.so    imtcp.so       imuxsock.so    lmnetstrms.so  lmregexp.so    lmtcpsrv.so    mmexternal.so  ommysql.so     omstdout.so
imfile.so      immark.so      imptcp.so      imudp.so       lmnet.so       lmnsd_ptcp.so  lmtcpclt.so    lmzlibw.so     ommail.so      omprog.so
/usr/lib/rsyslog# 
