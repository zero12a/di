1. 쿠버네티스 클러스터 생성하기
 - "클러스터만들기" 화면에서 왼쪽 메뉴 : default pool 확장하면 "노드" 선택해서 머신유형 지정 가능함.
 - 쿠버네티스 최신버전 또는 한국리전 선택하면 생성 실패함 ㅠㅠ
 - 디펄트로 놓고 생성해야 생성됨. 
 - 자동으로 지정된 주요 정보 : pod ip대역, 서비스 ip대역, 노드당 최대 pod 수 110 
 - 1개의 디펄트풀이 생성됨(추가가능) : 머신유형 e2-medium, vCPU 6개, 램12.00GB, 노드수 3(디펄트풀을 몇개 복제본 가질지 정보임,변경가능)

 - 1개의 인스턴스 그룹이 생성되며(무조건1개임)
    이름, 상태, 영역, 인스턴스, 생성일
    gke-cluster-1-default-pool-xxx-grp 	실행 중 us-central1-c 	1 	2020. 10. 30. PM 1:41:57 	

 - (1개의 디펄트풀 안에는 노드수 3의 설정정보 때문에) 아래와 같이 3개의 디펄트풀이 3개 생성되며
    gke-cluster-1-default-pool-xxxxx1 	Ready 	463 mCPU 	940 mCPU 	377.49 MB 	2.97 GB 	0 B 	0 B 	
    gke-cluster-1-default-pool-xxxxx2 	Ready 	369 mCPU 	940 mCPU 	594.54 MB 	2.97 GB 	0 B 	0 B 	
    gke-cluster-1-default-pool-xxxxx3 	Ready 	899 mCPU 	940 mCPU 	846.2 MB 	2.97 GB 	0 B 	0 B 

 - 위 1개의 노드풀에는 아래와 같이 클러스터 내부 서비스(kube-system)에 생성됨
    이름 상태, 요청한 CPU, 요청한 메모리, 요청한 저장용량, 네임스페이스, 재시작, 생성일
    kube-dns-xxx	                    Running 	260 mCPU 	115.34 MB 	0 B 	kube-system 	0 	2020. 10. 30. PM 1:44:58 	
    fluentd-gke-scaler-xxxx	            Running 	0 CPU 	0 B 	0 B 	kube-system 	0 	2020. 10. 30. PM 1:45:01 	
    gke-metrics-agent-xxxx              Running 	3 mCPU 	52.43 MB 	0 B 	kube-system 	0 	2020. 10. 30. PM 1:45:15 	
    prometheus-to-sd-xxx	            Running 	0 CPU 	0 B 	0 B 	kube-system 	0 	2020. 10. 30. PM 1:45:15 	
    kube-proxy-gke-cluster-1-default-pool-xxxx	Running 	100 mCPU 	0 B 	0 B 	kube-system 	0 	2020. 10. 30. PM 1:45:15 	
    fluentd-gke-xxxxx	                Running 	100 mCPU 	209.72 MB 	0 B 	kube-system 	0 	2020. 10. 30. PM 1:45:28 	


2. 컨테이너 레지스터리에 이미지 업로드 하기
 - 프로젝트 ID : impactful-bee-xxxx

3. 태그 붙이기
형식: docker tag [SOURCE_IMAGE] [HOSTNAME]/[PROJECT-ID]/[IMAGE]

docker tag msapm gcr.io/impactful-bee-xxxx/msapm

4. gcp cli 설치하기
brew install gcloud << 이건 안됨

https://cloud.google.com/sdk/docs/quickstart-macos?hl=ko 여기에서 다운로드 하기

내 맥북 비트수 확인하기
uname -a

다운로드
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-308.0.0-darwin-x86_64.tar.gz?hl=ko

설치하기
./install.sh

정상 설치 확인하기
gcloud --version

5. gcp 계정세팅하기
gcloud config set account zero12a@gmail.com

6. 프로젝트 id 설정
gcloud config set project impactful-bee-xxxxx

7. gcp 인증하기
gcloud auth login

8. gcp 토큰 인증추가하기 
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io

9. 레지스터리에 푸시하기
docker push gcr.io/impactful-bee-xxx/msapm
인증에러 발생함

=========================
10. 배포하기
 - 이미지 배포 피플리카는 몇개로 할지 지정 필요 (generation은 yaml정보수정 저장시마다 1씩 증가함, status는 참고정보로 수정불가)

12. 서비스로 오픈하기
 -  clusterIp, NodePort, 로드밸런서 3가지 종류가 있는데 로드밸런서로 선택해서 하면 자동으로 외부ip/po로 엔드포인트가 생성됨
  . clusterIp는 외부에서 호출안되는 클러스터링만 되는것이 was용
  . nodepoart는 클러스터ip에 임의 nodepor가 할당되는데 이건 어따써?


=========================
20. 서비스 삭제
21. 배포 삭제
22. 위와 같이 해도 VPC 외부 오픈ip객체는 남아 있으므로 수동 삭제 해야함