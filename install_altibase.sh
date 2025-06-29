#!/bin/bash

# 이 스크립트는 Docker 컨테이너 내부에서 altibase 사용자로 실행됩니다.

INSTALL_DIR="/opt/altibase"
ALTIBASE_TAR_GZ="/tmp/altibase_install/Altibase_HDB_7_1_0_9_0_Linux_64bit.tar.gz"

echo "INFO: Altibase 설치 파일 압축 해제 시작..."
tar -zxvf $ALTIBASE_TAR_GZ -C $INSTALL_DIR

# 압축 해제 후 생성되는 Altibase 홈 디렉토리의 이름을 확인해야 합니다.
# 일반적으로 tar.gz 파일명에 버전 정보가 포함되어 있어 해당 이름으로 디렉토리가 생성됩니다.
# 예: Altibase_HDB_7_1_0_9_0_Linux_64bit -> Altibase_HDB_7_1_0_9_0
# 정확한 디렉토리 이름 확인 필요. 여기서는 패턴 매칭으로 찾습니다.
ALTIBASE_HOME_DIR=$(ls -d ${INSTALL_DIR}/Altibase_HDB_* 2>/dev/null | head -1)

if [ -z "$ALTIBASE_HOME_DIR" ]; then
    echo "ERROR: Altibase 설치 디렉토리를 찾을 수 없습니다. 압축 해제 결과 확인 필요."
    exit 1
fi

# 심볼릭 링크 생성 (옵션, ALTIBASE_HOME을 고정된 경로로 사용하기 위함)
echo "INFO: Altibase 홈 디렉토리 심볼릭 링크 생성: ${INSTALL_DIR}/altibase_home -> ${ALTIBASE_HOME_DIR}"
ln -sfn $ALTIBASE_HOME_DIR ${INSTALL_DIR}/altibase_home

# Altibase 환경 설정 파일 (altibase_home/conf/altibase_env.sh) 수정 또는 생성
# 이 부분은 Altibase 설치 후 초기 DB 생성 및 설정에 따라 달라질 수 있습니다.
# 여기서는 간단히 ALTIBASE_HOME을 설정합니다.
echo "INFO: Altibase 환경 파일 설정..."
ALTIBASE_HOME=${INSTALL_DIR}/altibase_home
echo "export ALTIBASE_HOME=${ALTIBASE_HOME}" >> /home/altibase/.bashrc
echo "export PATH=\$PATH:\$ALTIBASE_HOME/bin" >> /home/altibase/.bashrc
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ALTIBASE_HOME/lib" >> /home/altibase/.bashrc

# 환경 변수 바로 적용 (이 스크립트가 실행되는 쉘에만 적용)
export ALTIBASE_HOME=${ALTIBASE_HOME}
export PATH=${PATH}:${ALTIBASE_HOME}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ALTIBASE_HOME}/lib

# Altibase 설치 완료 후, 필요한 경우 초기 데이터베이스 생성
# 이 부분은 자동화된 DB 생성을 원할 경우 추가합니다.
# 예를 들어, initdb, startup, createdb 등을 사용할 수 있습니다.
# 주의: 이 과정은 데이터베이스 설정을 포함하므로 신중하게 작성해야 합니다.
# 여기서는 설치만 완료하고 DB 생성은 컨테이너 실행 후 수동으로 하거나
# start_altibase.sh 스크립트에서 처리하는 것을 권장합니다.

echo "INFO: Altibase 설치 및 기본 설정 완료."
