o. aws cli 최신버전 설치하기(버전 1.18.149 이상 또는 버전 2.0.52 이상)
 > aws --version
 > curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
> 업그레이드 후 버전 2.0.50 -> 2.0.59

1. eksctl 인스톨하기
 -- https://github.com/weaveworks/eksctl
> brew install weaveworks/tap/eksctl ( or brew install eksctl )

2. aws eks 인증툴 설치하기(이미 설치되어 있다고 나옴, aws-cli있어서 그런듯)
> brew install aws-iam-authenticator

3. aws config에 정의된 사용자에게 Eks, Contain 권한 부여하기

4. aws웹콘솔에서 클러스터 생성하기
 - myEksCluster (10분정도 소요)
 - Subnat은 IP자동 할당되는 프라이빗이 1개이상 선택되어야 함.

5. Amazon EKS에 대한 kubeconfig 생성
 - 3번 권한이 없으면 다음과 같이 에러
 (An error occurred (AccessDeniedException) when calling the DescribeCluster operation: 
 User: arn:aws:iam::---:user/--- is not authorized to perform: eks:DescribeCluster on
  resource: arn:aws:eks:ap-northeast-2:---:cluster/myEksCluster)

> aws eks --region ap-northeast-2 update-kubeconfig --name myEksClusterPrivate --profile eks
aws --region ap-northeast-2 eks update-kubeconfig --name myEksClusterPrivate --role-arn arn:aws:iam::776092519253:role/myEksCluster

6. 지정된 config 확인하기
> kubectl config get-contexts


aws eks describe-cluster --name myEksClusterPrivate --query cluster.resourcesVpcConfig.clusterSecurityGroupId


6.1 웹콘솔에서 Role 생성
> 이름 : myEksCluster
> 정책 : AmazonEKSClusterPolicy , AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly
, mazonEKS_CNI_Policy, AmazonEKSFargatePodExecutionRolePolicy 

6. 클러스터 신규 생성
> eksctl create cluster  --name myEksClusterCli --region=ap-northeast-2 --version 1.18 --fargate \
   --resources-vpc-config subnetIds=<subnet-a9189fe2>,<subnet-50432629>,securityGroupIds=<sg-f5c54184>
or
eksctl create cluster  --name myEksClusterCli --version 1.18 --fargate --region ap-northeast-2 
-- 에러나서 "AWS::IAM::Role/ServiceRole: CREATE_FAILED – "API: iam:CreateRole User"
-- 조치 : 정책 AWSCloudFormationFullAccess이 myEksCluster에 대해 연결되었습니다. 

6 해당 클러스터 정보 조회
> eksctl get cluster --region=ap-northeast-2 --name=myEksClusterPrivate
[결과]
NAME		VERSION	STATUS	CREATED			VPC		SUBNETS							SECURITYGROUPS
myEksCluster	1.18	ACTIVE	2020-10-24T00:51:56Z	vpc-xxx	subnet-xxx,subnet-xxx	sg-xxx

7. 웹콘솔에서 프로파일 생성(10분이상소요)
 - my-profile-private, my-namespace-private
 - subnat은 private로 선택

8. 프로파일 파일 생성
- 권한이 없으면 아래와 같이 에러
 (Error: describing CloudFormation stacks for "myEksCluster": 
 AccessDenied: User: arn:aws:iam::xxx:user/xxx is not authorized to perform: cloudformation:ListStacks 
 on resource: arn:aws:cloudformation:ap-northeast-2:xxx:stack/*/*
	status code: 403, request id: 6173f25b-d09f-41c7-96ea-xxx)
- 권한 추가 후에도 아래와 같이 에러
 (Error: no eksctl-managed CloudFormation stacks found for "myEksCluster")

> eksctl create fargateprofile \
    --cluster myEksCluster \
    --name 2048-game \
    --namespace 2048-game

eksctl create fargateprofile     --cluster myEksClusterPrivate     --name 2048-game     --namespace 2048-game

eksctl create fargateprofile     --cluster myEksClusterPrivate     --name zero12g-profile --namespace zero12g-namespace


9. 조회 하기
- 권한이 없으면 에러 발생
(eksctl get fargateprofile --cluster myEksClusterPrivate
Error: failed to get Fargate profile(s) for cluster "myEksClusterPrivate": AccessDeniedException:)

> eksctl get fargateprofile --cluster myEksClusterPrivate -o yaml

10. sts 토큰 정보 가져오기
aws eks get-token --cluster-name myEksClusterPrivate

11. 역활전환를 위하여 신뢰 정책 편집 (myEksRole)
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::xxx:user/xxx"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}



aws-iam-authenticator token -i myEksClusterPrivate
aws-iam-authenticator verify -t k8s-aws-v1.really_long_token -i myEksClusterPrivate


aws eks --region ap-northeast-2 update-kubeconfig --name myEksClusterPrivate


#현재 프로파일 세팅
> export AWS_PROFILE=eksadmin
> echo $AWS_PROFILE

#인증 캐쉬 지우고
rm -r ~/.aws/cli/cache

#현재 접속자 인증 정보 확인학
aws sts get-caller-identity

aws eks update-kubeconfig --name myEksClusterPrivate --region ap-northeast-2 --role-arn arn:aws:iam::776092519253:role/myEksCluster
 -> error: You must be logged in to the server (Unauthorized)

위 인가 에러나서 이거 해도 똑같은 에러남
kubectl describe configmap -n kube-system aws-auth
 -> error: You must be logged in to the server (Unauthorized)

aws sts assume-role --role-arn arn:aws:iam::776092519253:role/myEksCluster --role-session-name abcde

aws eks update-kubeconfig --name myEksClusterPrivate --role-arn arn:aws:iam::776092519253:role/myEksCluster

kubectl get clusterrole


eksctl create cluster \
 --name myEksClusterCli2 \
 --version 1.18 \
 --without-nodegroup

-cli에서 zero12g계정의 apikey로 eks 클러스터 생성하려면 아래 IAM에서 zero12g 사용자에게 인라인 정책 아래 Json추가
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
