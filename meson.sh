#!/bin/bash

# 색깔 변수 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

print_command() {
  echo -e "${BOLD}${YELLOW}$1${RESET}"
}

echo -e "${GREEN}Meson network 노드 설치를 시작합니다.${NC}"

# 사용자에게 명령어 결과를 강제로 보여주는 함수
req() {
  echo -e "${YELLOW}$1${NC}"
  shift
  "$@"
  echo -e "${YELLOW}결과를 확인한 후 엔터를 눌러 계속 진행하세요.${NC}"
  read -r
}

# 홈 디렉토리로 이동합니다.
cd $HOME

# 필요한 파일을 다운로드하고 압축을 해제니다.
curl -o apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz && tar -zxf apphub-linux-amd64.tar.gz && rm -f apphub-linux-amd64.tar.gz && cd ./apphub-linux-amd64

# 기존 서비스를 제거하고 새 서비스를 설치합니다.
sudo ./apphub service remove && sudo ./apphub service install

# 서비스를 실행합니다.
sudo ./apphub service start

# 노드의 개인키 및 본인의 IP를 표시합니다.
req "서비스가 OK로 출력되는지 확인하시고 엔터를 누르세요" sudo ./apphub status

# 웹과 연동.
echo -e "${GREEN}https://dashboard.gaganode.com/install_run 해당 사이트에 접속하여 토큰ID를 복사하세요.${NC}"

# 사용자로부터 토큰 ID를 입력받습니다.
read -p "위 사이트에서 복사한 토큰 ID를 입력해주세요: " TOKEN_ID

# 입력받은 토큰 ID를 사용하여 명령어를 실행합니다.
echo -e "${YELLOW}토큰 ID를 사용하여 Gaganode 설정을 적용합니다.${NC}"
sudo ./apps/gaganode/gaganode config set --token="$TOKEN_ID"

# 현재 사용 중인 포트 확인
used_ports=$(netstat -tuln | awk '{print $4}' | grep -o '[0-9]*$' | sort -u)

# 각 포트에 대해 ufw allow 실행
for port in $used_ports; do
    echo -e "${GREEN}포트 ${port}을(를) 허용합니다.${NC}"
    sudo ufw allow $port
    sudo ufw allow 5060/tcp
    sudo ufw allow 36060/tcp
done

echo -e "${GREEN}모든 사용 중인 포트가 허용되었습니다.${NC}"

# 서비스 상태를 다시 확인합니다.
req "status가 running으로 출력되는지 다시 한번 확인하세요." sudo ./apphub status
echo -e "${GREEN}해당 사이트에 방문하여 대시보드를 확인하세요:https://dashboard.gaganode.com/nodes${NC}"
echo -e "${GREEN}모든 작업이 완료되었습니다. 컨트롤+A+D로 스크린을 종료해주세요.${NC}"
echo -e "${GREEN}스크립트 작성자: https://t.me/kjkresearch${NC}"
