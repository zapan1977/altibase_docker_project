#!/bin/bash

# 환경 변수 로드 (Dockerfile에서 설정한 ALTIBASE_HOME 등)
# altibase 사용자의 .bashrc에 환경 변수가 설정되어 있다면 로드합니다.
if [ -f "/home/altibase/.bashrc" ]; then
    source /home/altibase/.bashrc
fi

echo "INFO: Starting Altibase database server..."
# Altibase 서버 시작
$ALTIBASE_HOME/bin/startup

# Altibase 서버가 완전히 시작될 때까지 기다릴 수 있습니다 (옵션)
# 예: check the log file or process status
sleep 5 # 임시 대기

# Altibase가 백그라운드 프로세스로 실행되므로, Docker 컨테이너가 종료되지 않도록 유지
echo "INFO: Altibase server started. Keeping container alive..."
tail -f /dev/null # 컨테이너가 종료되지 않도록 무한히 대기
