# swoole 비동기 redis의 경우 https://github.com/swoole/ext-async 프로젝트 변경됨
wget https://github.com/swoole/ext-async/archive/v4.4.14.tar.gz
tar xvfz v4.4.14.tar.gz
cd ext-async
phpize
./configure
make -j 4
sudo make install
=> php.ini 에  ㄷㅌ swoole_aync.so 활성화필요

# swoole 설치 상태 보기
php --ri swoole

swoole

Swoole => enabled
Author => Swoole Team <team@swoole.com>
Version => 4.4.14
Built => Jan 11 2020 12:06:54
coroutine => enabled
epoll => enabled
eventfd => enabled
signalfd => enabled
cpu_affinity => enabled
spinlock => enabled
rwlock => enabled
mutex_timedlock => enabled
pthread_barrier => enabled
futex => enabled
async_redis => enabled

Directive => Local Value => Master Value
swoole.enable_coroutine => On => On
swoole.enable_library => On => On
swoole.enable_preemptive_scheduler => Off => Off
swoole.display_errors => On => On
swoole.use_shortname => On => On
swoole.unixsock_buffer_size => 8388608 => 8388608
