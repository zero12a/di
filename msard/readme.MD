쉬운 배포를 위한 준비

1. 한방에 설치 클라우드 포메이션.
 - rd, os2, lib, lc, redis, mysql
 - rd : redis정보
 - os2 : redis정보
 - lib : x
 - lc : redis정보
 - redis : 초기pw (버전6이상은 id/비번 인증.)
 - mysql : 초기 빈db, 사용자id/비번

2. 엔터프라이즈 환경 인증
 - (rank1) 인증만 외부로 분리하고 인가는 내부처리?
  . 개발놓은 ldap소스 확보 필요.

3. rd초기 세팅
 <설치형>
 - (rank2) redis_config.php를 통해 설정 (암호화 컬럼도 암호화 풀려서 직접 설정가능하게 해야함)
  . 암호화키(초최1회만 설정, 변경은 불가하고 초기화시 암호화키/일반파라미터 모두 clean)
  . 암호화키와 일반파라미터 분리?
  . 일반파라미터는 암호화컬럼 여부 정의 필요 (ex> param1.param2, DBSTORE.DBPW)

 <사용자 친화>
 - step1 : 프로젝트명, 암호화키, 인증방식 결정(ldap 또는 os2)
   . 로컬인증 또는 ldap인증
 - step2 : redis정보, mysql정보(로그,로컬사용자), 파일스토어
   . (불필요) redis 1개 : ip port pw 정의 필요
   . mysql 다수: SVRID는 고정되어 있고 연결정보만 변경가능
   . filestore 다수 : FILESTOREID는 고정되어 있고 연결정보만 변경가능
 - step3 : 초기 db 업로드
   . github 원격 URL에 사용가능

