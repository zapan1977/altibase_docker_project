# Dockerfile

# Rocky Linux 8.10을 기본 이미지로 사용합니다.
FROM rockylinux/rockylinux:8.10

# 이미지 빌더의 메타데이터를 설정합니다.
LABEL maintainer="bintan.kpsec@gmail.com"
LABEL description="Altibase HDB 7.1.0.9.0 on Rocky Linux 8.10"

# Altibase 설치에 필요한 패키지들을 설치하고, 불필요한 캐시를 정리합니다.
# dnf update -y --disableplugin=subscription-manager --exclude=redhat-release* --exclude=rhn-client-tools* \
# dnf는 구독 관리자 플러그인을 기본적으로 사용하기 때문에, Rocky Linux에서는 --disableplugin=subscription-manager 를 추가하여 구독 관련 경고나 오류를 방지합니다.
# 또한, redhat-release* 나 rhn-client-tools* 와 같이 Red Hat 관련 패키지를 제외하는 것이 좋습니다.
RUN dnf update -y --disableplugin=subscription-manager && \
    dnf install -y \
        gcc \
        make \
        libaio \
        libaio-devel \
        glibc-headers \
        compat-libstdc++-33 \
        net-tools \
        bc \
        gzip \
        tar \
        unzip \
    --disableplugin=subscription-manager && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Altibase 사용자 및 그룹을 생성합니다.
RUN groupadd -g 2000 altibase && useradd -u 2000 -g altibase -m -d /home/altibase -s /bin/bash altibase

# Altibase 설치 디렉토리를 생성하고 권한을 부여합니다.
RUN mkdir -p /opt/altibase && chown -R altibase:altibase /opt/altibase

# Altibase 설치 파일 복사를 위한 임시 디렉토리를 생성합니다.
RUN mkdir -p /tmp/altibase_install

# Altibase 설치 파일을 컨테이너 내부로 복사합니다.
# 이 경로는 호스트 머신에 Altibase 설치 파일이 있는 경로와 일치해야 합니다.
# 예: Altibase_HDB_7_1_0_9_0_Linux_64bit.tar.gz
COPY Altibase_HDB_7_1_0_9_0_Linux_64bit.tar.gz /tmp/altibase_install/

# Altibase 설치 스크립트를 컨테이너 내부로 복사합니다.
# 이 스크립트는 Altibase 설치 과정에 필요한 추가 설정이나 자동화를 위해 사용됩니다.
# 예: install_altibase.sh
COPY install_altibase.sh /tmp/altibase_install/

# Altibase 설치 스크립트 권한 부여
RUN chmod +x /tmp/altibase_install/install_altibase.sh

# Altibase 설치 및 환경 설정
# altibase 사용자로 전환하여 설치 스크립트를 실행합니다.
USER altibase
WORKDIR /home/altibase

# Altibase 설치 스크립트 실행
# 설치 스크립트는 /tmp/altibase_install 에 있는 tar.gz 파일을 /opt/altibase 에 압축 해제하고 환경 설정을 할 것입니다.
RUN /tmp/altibase_install/install_altibase.sh

# Altibase 환경 변수를 설정합니다.
# ALT_HOME을 /opt/altibase/altibase_home 으로 가정합니다.
ENV ALTIBASE_HOME=/opt/altibase/altibase_home
ENV PATH=$PATH:$ALTIBASE_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ALTIBASE_HOME/lib

# Altibase 데이터베이스 포트를 노출합니다.
# 기본 포트는 20300 입니다.
EXPOSE 20300

# 컨테이너 시작 시 Altibase를 자동으로 시작하는 스크립트를 정의합니다.
# 이 스크립트는 실제 Altibase 서버를 구동하는 역할을 합니다.
# CMD ["bash", "-c", "$ALTIBASE_HOME/bin/startup"]
# Altibase는 백그라운드 프로세스로 실행되므로, 컨테이너가 종료되지 않도록 
# tail -f /dev/null 와 같은 명령어를 추가하여 컨테이너가 계속 실행되도록 합니다.
# Altibase 시작 스크립트(start_altibase.sh)를 별도로 만들어 활용하는 것이 좋습니다.
COPY start_altibase.sh /home/altibase/
RUN chmod +x /home/altibase/start_altibase.sh

# 컨테이너 실행 시 Altibase 시작 스크립트를 실행합니다.
CMD ["/home/altibase/start_altibase.sh"]
