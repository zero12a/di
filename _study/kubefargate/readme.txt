1. IAM 일반 유저 zero12XXX에게 eks 리소스 권한 부여
- https://stackoverflow.com/questions/56011492/accessdeniedexception-creating-eks-cluster-user-is-not-authorized-to-perform
- cli에서 zero12g계정의 apikey로 eks 클러스터 생성하려면 아래 IAM에서 zero12g 사용자에게 인라인 정책 아래 Json추가
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "eksadministrator",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        }
    ]
}

2. EKS클러스터 생성하기
 > eksctl create cluster  --name myzero12gclustercli --region=ap-northeast-2 --version 1.18 --fargate 
 - 디펄트로 프로파일이 생성됨 : 프로파일이름=fp-default, 네임스페이스=default, kube-system

 > eksctl create cluster  --name myzero12gclustercli2 --region=ap-northeast-2 --version 1.18 --fargate 


3. 클러스터 선택
 > aws eks --region ap-northeast-2 update-kubeconfig --name myzero12gclustercli2

4.생성된 kube 시스템 데몬들이 정상인지확인 하기
 > kubectl get all -n kube-system

YOUNGui-MacBook-Air:kubefargate zeroone$ kubectl get all -n kube-system
NAME                          READY   STATUS    RESTARTS   AGE
pod/coredns-97b75d8d6-bm2d2   1/1     Running   0          6m7s
pod/coredns-97b75d8d6-cpwxj   1/1     Running   0          6m7s

NAME               TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
service/kube-dns   ClusterIP   10.100.0.10   <none>        53/UDP,53/TCP   9m8s

NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/aws-node     0         0         0       0            0           <none>          9m9s
daemonset.apps/kube-proxy   0         0         0       0            0           <none>          9m8s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/coredns   2/2     2            2           9m8s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/coredns-6fb4cf484b   0         0         0       9m
replicaset.apps/coredns-97b75d8d6    2         2         2       6m7s
YOUNGui-MacBook-Air:kubefargate zeroone$ 


3. 생성된 클러스터 정보조회
* 목록조회
 > eksctl get cluster --region=ap-northeast-2 
* 특정클러스터 상세조회
 > eksctl get cluster --region=ap-northeast-2 --name=myzero12gclustercli

4. 클러스터 내부에 fargate 프로파일 추가 생성하기(불필요, 클러스터 생성시 자동 디펄트 생성됨)
 > eksctl create fargateprofile --cluster myzero12gclustercli --name zero12g-profile --namespace default
 > eksctl create fargateprofile --cluster myzero12gclustercli --name zero12g-profile2 --namespace kube-system

==명령어 취트쉬트==
https://kubernetes.io/ko/docs/reference/kubectl/cheatsheet/



5. 클러스터 구성이 온바른지 확인
 > kubectl get svc
YOUNGui-MacBook-Air:.aws zeroone$ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   11m

6. 배포 yaml 서비스 만들고 배포하기
 > kubectl apply -f sample-service.yaml  << 이거 안하면 아래 서비스 목록에 안 나옴
 > kubectl apply -f sample-deployment.yaml
<동합실행>
 > kubectl apply -f sample-app.yaml

7. 배포된 서비스 확인하기
 > kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.100.0.1       <none>        443/TCP   17m
my-service   ClusterIP   10.100.194.165   <none>        80/TCP    16s

8. 서비스 확인하기
 > kubectl get svc my-service

9. 디폴로이 먼트 확인하기
 > kubectl get deployments my-deployment
 > kubectl describe deployments my-deployment

10. 리프리카 정보 확인
> kubectl get replicasets
 > kubectl describe replicasets

11. pod정보 확인해 보기 (pending 상태임 --> 확인해 보니 프로파일이 없어서 ?)
YOUNGui-MacBook-Air:kubefargate zeroone$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
my-nginx-6b474476c4-779sm   0/1     Pending   0          7m26s
my-nginx-6b474476c4-dtpnq   0/1     Pending   0          7m26s
my-nginx-6b474476c4-sxg2m   0/1     Pending   0          7m26s

aws eks describe-cluster --name myzero12gcustercli --query cluster.resourcesVpcConfig.securityGroupIds



12. pod os로 진입하기
> kubectl exec --stdin --tty my-nginx-6b474476c4-8b48k -- /bin/bash











9. 외부오픈 서비스 오브젝트 생성
 > kubectl expose deployment my-deployment --type=LoadBalancer --name=my-externalsvc

10. 외부오픈 서비스 확인
 > kubectl get services 
 kubectl get services
NAME             TYPE           CLUSTER-IP       EXTERNAL-IP                                                                    PORT(S)        AGE
kubernetes       ClusterIP      10.100.0.1       <none>                                                                         443/TCP        50m
my-externalsvc   LoadBalancer   10.100.170.57    a30xxxxx.ap-northeast-2.elb.amazonaws.com   80:30206/TCP   24s
my-service       ClusterIP      10.100.194.165   <none>                                                                         80/TCP         34m

11. 외부 오픈 서비스 상세 정보 확인
 > kubectl describe services my-externalsvc


11. 서비스를 인그레스로 로드밸린싱하기 오픈
 > kubectl apply -f sample-ingress.yaml

12. 생성된 인그레스 확인
 >   kubectl get ingress
NAME         CLASS    HOSTS              ADDRESS   PORTS   AGE
my-ingress   <none>   my-service.local             80      28s

13. 생성된거 지우기
 > kubectl delete services my-service
 > kubectl delete deployment my-deployment
 > kubectl delete services my-externalsvc
 <동시삭제>
 > kubectl delete deployment/my-deployment services/my-service
 > kubectl delete deployments/my-nginx services/my-nginx-svc ingress/my-ingress
