# Cornix ZMK 빌드 가이드

이 문서는 Cornix 키보드를 위한 ZMK 펌웨어를 올바르게 빌드하는 방법을 설명합니다.

## 빌드 환경 요구사항

### 필수 도구

- **Git**: 소스 코드 관리
- **West**: ZMK 패키지 매니저 및 빌드 시스템
- **Python 3.8+**: West 실행을 위해 필요
- **CMake 3.20+**: 빌드 시스템
- **Ninja 또는 Make**: 빌드 도구
- **Zephyr SDK**: 교차 컴파일러 툴체인

### 추천 개발 환경

- **Just**: 빌드 자동화 도구 (이 프로젝트에서 사용)
- **Nix**: 재현 가능한 개발 환경 (flake.nix 제공)

## 초기 설정

### 1. 저장소 클론

```bash
git clone https://github.com/YOUR_USERNAME/cornix-zmk-config.git
cd cornix-zmk-config
```

### 2. West 워크스페이스 초기화

```bash
# Just를 사용하는 경우
just init

# 수동으로 실행하는 경우
west init -l config/
west update --fetch-opt=--filter=blob:none
west zephyr-export
```

### 3. 종속성 업데이트

```bash
# Just를 사용하는 경우
just update

# 수동으로 실행하는 경우
west update --fetch-opt=--filter=blob:none
```

## 빌드 타겟 구성

현재 `build.yaml`에 정의된 빌드 타겟들:

### 기본 구성 (동글 없이 사용)

- **cornix_left**: 왼쪽 반쪽 키보드
- **cornix_right**: 오른쪽 반쪽 키보드
- **reset**: 설정 리셋 펌웨어

### 추가 구성 옵션

#### RGB 지원 추가
`build.yaml`에서 다음과 같이 shield를 추가할 수 있습니다:
```yaml
- board: cornix_left
  shield: cornix_indicator
  artifact-name: cornix_left_rgb
```

#### 동글 사용 구성
동글을 사용하는 경우 다음 구성을 `build.yaml`에 추가:
```yaml
- board: cornix_dongle
  shield: cornix_dongle_eyelash dongle_display
  snippet: studio-rpc-usb-uart
  artifact-name: cornix_dongle

- board: cornix_ph_left
  artifact-name: cornix_left_for_dongle
```

## 빌드 실행

### Just를 사용한 빌드 (추천)

```bash
# 사용 가능한 타겟 목록 보기
just list

# 모든 타겟 빌드
just build all

# 특정 타겟 빌드
just build cornix_left
just build cornix_right
just build reset

# 빌드 캐시 정리
just clean
```

### 수동 West 빌드

```bash
# 왼쪽 반쪽 빌드
west build -s zmk/app -b cornix_left -- -DZMK_CONFIG=config/

# 오른쪽 반쪽 빌드
west build -s zmk/app -b cornix_right -- -DZMK_CONFIG=config/

# 리셋 펌웨어 빌드
west build -s zmk/app -b cornix_right -- -DZMK_CONFIG=config/ -DSHIELD=settings_reset

# 깨끗한 빌드 (이전 빌드 결과 제거)
west build -p -s zmk/app -b cornix_left -- -DZMK_CONFIG=config/
```

## 키맵 커스터마이징

### 1. 키맵 파일 생성

`config/` 디렉토리에 새 키맵 파일을 생성합니다:

```c
// config/my_cornix.keymap
#include "zmk-helpers/helper.h"
#include "includes/cornix54.h"
#include <behaviors.dtsi>
#include <dt-bindings/zmk/bt.h>
#include <dt-bindings/zmk/keys.h>

/ {
    keymap {
        compatible = "zmk,keymap";
        
        default_layer {
            bindings = <
                // 키맵 정의
            >;
        };
    };
};
```

### 2. 키 위치 참조

Cornix는 54키 레이아웃을 사용합니다. `includes/cornix54.h`에서 정의된 키 위치:

- **LT0~LT5**: 왼쪽 상단 행
- **LM0~LM5**: 왼쪽 중간 행
- **LB0~LB5**: 왼쪽 하단 행
- **LH0~LH3**: 왼쪽 엄지 키
- **RT0~RT5**: 오른쪽 상단 행
- **RM0~RM5**: 오른쪽 중간 행
- **RB0~RB5**: 오른쪽 하단 행
- **RH0~RH3**: 오른쪽 엄지 키

### 3. ZMK-Helpers 활용

```c
// 홀드-탭 동작 정의
ZMK_HOLD_TAP(hm,
    flavor = "tap-preferred";
    tapping-term-ms = <200>;
    bindings = <&kp>, <&kp>;
)

// 콤보 정의
ZMK_COMBO(esc, &kp ESC, LT1 LT2, ALL)

// 레이어 정의
ZMK_LAYER(lower,
    // 키맵 바인딩
)
```

## 설정 파일 (.conf)

키보드 동작을 제어하는 설정은 `.conf` 파일에서 관리합니다:

```ini
# config/cornix.conf

# 블루투스 설정
CONFIG_ZMK_BLE=y
CONFIG_BT_CTLR_TX_PWR_PLUS_8=y

# 배터리 모니터링
CONFIG_ZMK_BATTERY_REPORT_INTERVAL=60

# RGB 설정 (cornix_indicator 사용 시)
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_WS2812_STRIP=y

# 콤보 설정
CONFIG_ZMK_COMBO_MAX_PRESSED_COMBOS=10
CONFIG_ZMK_COMBO_MAX_COMBOS_PER_KEY=5

# 로우 파워 모드
CONFIG_ZMK_SLEEP=y
CONFIG_ZMK_IDLE_TIMEOUT=30000
```

## 빌드 출력 확인

### 성공적인 빌드

빌드가 성공하면 다음 위치에 파일이 생성됩니다:

```
firmware/
├── cornix_left.uf2
├── cornix_right.uf2
└── reset.uf2
```

### 빌드 로그 확인

```bash
# Just 사용 시 상세 로그
just build cornix_left --verbose

# West 사용 시 상세 로그
west build -s zmk/app -b cornix_left -v -- -DZMK_CONFIG=config/
```

## 플래싱 가이드

### 1. 부트로더 모드 진입

1. Cornix 키보드를 USB 케이블로 연결
2. 리셋 버튼을 두 번 빠르게 누름
3. 키보드가 USB 저장 장치로 인식됨

### 2. 펌웨어 플래싱

```bash
# 1단계: 양쪽 반쪽에 리셋 펌웨어 플래싱
# 왼쪽 → reset.uf2 복사
# 오른쪽 → reset.uf2 복사

# 2단계: 실제 펌웨어 플래싱
# 왼쪽 → cornix_left.uf2 복사
# 오른쪽 → cornix_right.uf2 복사

# 3단계: 양쪽 키보드 동시에 리셋
```

### 3. 블루투스 페어링

1. 왼쪽 키보드(중앙)를 먼저 연결
2. USB로 먼저 테스트
3. 블루투스 연결 시 모바일 기기로 먼저 테스트 권장

## 문제 해결

### 빌드 오류

```bash
# 빌드 캐시 완전 정리
just clean-all

# West 캐시 정리
west clean
rm -rf .west build

# 종속성 재설치
just init
```

### 키보드 연결 문제

1. **USB 연결 실패**: 케이블 및 포트 확인
2. **블루투스 연결 실패**: 
   - 기존 페어링 정보 삭제
   - 양쪽 키보드 동시 리셋
   - 모바일 기기로 먼저 테스트
3. **키 입력 안됨**: 키맵 설정 확인

### 배터리 문제

```ini
# 배터리 절약 설정
CONFIG_ZMK_IDLE_TIMEOUT=15000
CONFIG_ZMK_SLEEP=y

# RGB 비활성화 (높은 전력 소모)
# CONFIG_ZMK_RGB_UNDERGLOW=n
```

## 고급 빌드 옵션

### 외부 모듈 사용

```bash
west build -s zmk/app -b cornix_left -- \
  -DZMK_CONFIG=config/ \
  -DZMK_EXTRA_MODULES="/path/to/extra/module"
```

### 컴파일 커맨드 DB 생성

```bash
west config build.cmake-args -- "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
```

### 테스트 빌드

```bash
# 테스트 실행
just test path/to/test --verbose

# 자동 승인 모드
just test path/to/test --auto-accept
```

## 개발 워크플로우

### 1. 키맵 수정
1. `config/` 디렉토리에서 키맵 파일 편집
2. 로컬 빌드로 테스트
3. Git 커밋

### 2. 자동 빌드
- GitHub에 푸시하면 자동으로 GitHub Actions에서 빌드
- 빌드된 펌웨어는 Actions 아티팩트에서 다운로드

### 3. 버전 관리
- 태그를 사용하여 안정된 버전 관리
- 브랜치별로 다른 키맵 구성 가능

## 참고 자료

- [ZMK 공식 문서](https://zmk.dev/docs)
- [Cornix 키보드 가이드](https://github.com/hitsmaxft/zmk-keyboard-cornix)
- [ZMK Helpers](https://github.com/urob/zmk-helpers)
- [Zephyr 프로젝트](https://zephyrproject.org/)