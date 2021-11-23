1. (로컬pc) 다운로드
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.0.1/docker-compose.yaml'

2. (로컬pc) 폴더/파일 생성
mkdir ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > .env

3. vm이미지 생성하기
docker-compose up airflow-init

<결과:정상>
airflow-init_1       | Upgrades done
airflow-init_1       | Admin user airflow created
airflow-init_1       | 2.0.1
start_airflow-init_1 exited with code 0

<결과:실패>
ttaching to airflow_airflow-init_1
airflow-init_1       | WARNING: no logs are available with the 'syslog' log driver
airflow_airflow-init_1 exited with code 0

docker ps 결과 아래 2개 프로세스만 뜸.
64962d669669   postgres:13                 "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes (healthy)   5432/tcp                                     airflow_postgres_1
bfb506eb3a10   redis:latest                "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes (healthy)   0.0.0.0:6379->6379/tcp                       airflow_redis_1


4. 데몬 띄우기
docker-compose up



5. 데몬 프로세스 확인
> docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS                    PORTS                              NAMES
247ebe6cf87a   apache/airflow:2.0.1   "/usr/bin/dumb-init …"   3 minutes ago    Up 3 minutes              8080/tcp                           compose_airflow-worker_1
ed9b09fc84b1   apache/airflow:2.0.1   "/usr/bin/dumb-init …"   3 minutes ago    Up 3 minutes              8080/tcp                           compose_airflow-scheduler_1
65ac1da2c219   apache/airflow:2.0.1   "/usr/bin/dumb-init …"   3 minutes ago    Up 3 minutes (healthy)    0.0.0.0:5555->5555/tcp, 8080/tcp   compose_flower_1
7cb1fb603a98   apache/airflow:2.0.1   "/usr/bin/dumb-init …"   3 minutes ago    Up 3 minutes (healthy)    0.0.0.0:8080->8080/tcp             compose_airflow-webserver_1
74f3bbe506eb   postgres:13            "docker-entrypoint.s…"   18 minutes ago   Up 17 minutes (healthy)   5432/tcp                           compose_postgres_1
0bd6576d23cb   redis:latest           "docker-entrypoint.s…"   10 hours ago     Up 17 minutes (healthy)   0.0.0.0:6379->6379/tcp             compose_redis_1

6. 성공했으나 cpu를 100%계속 유지됨 (ㅠㅠ)