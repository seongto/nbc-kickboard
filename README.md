# 킥보드의 정석 프로젝트
---
![Frame 107](https://github.com/user-attachments/assets/6748ec98-1d58-4ea8-81bc-4f2f16b0a325)


## 📖 **프로젝트 개요**

**킥보드의 정석**은 주변의 킥보드 위치 정보를 제공하고, 사용자가 정보를 확인한 후 대여할 수 있는 iOS 앱 서비스입니다. 사용자는 로그인 후 지도를 통해 주변 킥보드를 확인하거나, 새로운 킥보드를 등록할 수 있습니다. 관리자 모드를 통해 킥보드를 추가하고, 마이페이지에서는 대여 내역을 확인할 수 있습니다.

- **프로젝트 기간:** 2024.12.13 ~ 2024.12.19
- **개발 환경:** Xcode 16, iOS 16.6
- **UI 프레임워크:** UIKit
- **버전 관리:** Git (브랜치 전략: `main`, `develop`, `feature/*`)
- **디자인 툴:** Figma


---

# 멤버별 주요 역할

## 👥 **권승용**

### **주요 역할: 마이페이지 개발, 코어데이터스택 구현**

- **마이페이지 개발**
    - 마이페이지 화면 UI 및 기능 개발
    - 내역 화면 UI 및 기능 개발
- **코어데이터스택 구현**
    - User, Kickboard, KickboardType, History 각 엔티티에 대한 CRUD를 제공하는 코어데이터스택 구현
    - 사용하는 객체에서는 코어데이터를 몰라도 되도록 레포지토리 패턴 적용

---

## 👥 **김석준**

### **주요 역할: 검색 기능 개발, 네트워크 통신 담당**

- **검색 기능 개발**
    - **주소 기반 검색**: 카카오 및 네이버 API 연동
    - **자동 완성 기능**: 사용자 입력에 따른 검색어 자동 완성 기능 구현
    - **지도와의 연동**: 검색 결과에 따른 지도 뷰 이동 구현
- **네트워크 통신**
    - 서버 API 연동 (GET, POST 요청 처리)
    - **데이터 파싱**: 네트워크 요청 결과를 JSON으로 파싱하여 사용
    - **에러 처리**: API 실패에 따른 예외 처리 및 재시도 로직 추가

---

## 👥 **김형석**

### **주요 역할: 메인 페이지 개발, 지도 기능 구현**

- **메인 페이지 개발**
    - **지도 뷰 구현**: MapKit을 활용하여 지도 위에 킥보드 마커 표시
    - **위치 기반 서비스**: 사용자 위치 정보 추적 및 현재 위치에 따른 지도 이동
    - **대여/반납 기능**: 킥보드 선택 후 대여 및 반납 기능 구현
- **네트워크 통신**
    - **실시간 위치 데이터 연동**: 서버로부터 실시간 데이터 불러오기
    - **지도 데이터 최적화**: 지도 줌 인/아웃에 따른 데이터 최적화
- **버그 수정**
    - 지도 뷰의 마커 오프셋 오류 수정
    - 마커 클릭 시 상세 정보 팝업 오류 해결

---

## 👥 **임성수**

### **주요 역할: 로그인/회원가입 개발, Git 리뷰어**

- **로그인/회원가입 기능**
    - **로그인 로직 구현**: 이메일/비밀번호 입력 및 검증 기능 구현
    - **회원가입 유효성 검사**: 비밀번호 길이 및 입력 값 유효성 검사 추가
    - **로그인 유지**: UserDefaults를 활용하여 로그인 정보 저장 및 자동 로그인 기능 구현
- **UI/UX 개선**
    - **로그인 화면 개선**: UI 간소화 및 사용자 친화적인 UX 개선
    - **로그인 실패 알림**: 로그인 실패 시 에러 메시지 추가
- **Git 리뷰어**
    - 팀원들의 **Pull Request(PR) 리뷰**
    - **코드 컨벤션 검사** 및 리뷰 후 머지 승인
    - Git 충돌 발생 시 직접 해결 및 가이드 제공

---

## 👥 **전성규**

### **주요 역할: 관리자 모드 개발, 코드 리뷰어**

- **관리자 모드 개발**
    - **킥보드 추가/삭제 기능**: 관리자 전용 기능으로 신규 킥보드 추가 및 삭제 기능 구현
    - **UI/UX 개선**: 관리자 페이지의 UI 개선 및 버튼 인터랙션 추가
    - **데이터 관리 기능**: 관리자가 킥보드 데이터(위치, 상태 등)를 수정할 수 있는 인터페이스 구현
- **코드 리뷰어**
    - Pull Request(PR) 코드 검토 및 리뷰
    - **머지 과정 관리**: develop 브랜치에 머지 시 코드 품질 점검
    - **코드 컨벤션 가이드 제공**: 코드 스타일 및 컨벤션 지침 제공

---

## 📜 **프로젝트 규칙**

### ⚠️ **Ground Rules**

- **점심 시간**: 12:00 ~ 13:00
- **저녁 시간**: 18:00 ~ 19:00
- 자리 비울 시 채팅창에 알림 필수

### 🎯 **프로젝트 목표**

- **제시간에 과제 제출** 🕐
- **서로의 질문을 외면하지 않기** 🙋‍♀️🙋‍♂️
- **밥을 굶지 않고 공부하기** 🍚

---

## 🚀 **진행 상황**

### ✅ 기본 과제

- [x]  로그인 화면/회원가입 화면
- [x]  지도 페이지 (사용자 위치 기반의 킥보드 정보 제공)
- [x]  킥보드 등록 페이지 (사용자가 직접 킥보드 정보 등록 가능)
- [x]  마이 페이지 (킥보드 이용내역, 로그인/로그아웃 기능)

### ⚙️ 심화 목표

- [x]  메인(지도) 페이지 UI 개선
- [x]  킥보드 등록 페이지
- [ ]  마이페이지에서 등록한 킥보드 수정 및 삭제

---

## ⚙️ **개발 목표 및 기술 스택**

| **구분** | **세부 사항** |
| --- | --- |
| **개발 아키텍처** | **MVC** 구조로 개발 후, 필요에 따라 추가 패턴이나 레이어 적용 |
| **지도 기능** | **MapKit**, **Kakao 지도 API** 활용 |
| **데이터 관리** | **CoreData** 및 **UserDefaults**를 통한 데이터 관리 |
| **네트워크 통신** | Alamofire 사용 가능 |
| **UI 개발** | **UIKit**, **AutoLayout**, **SnapKit**, **Combine**  사용 |
| **코드 관리** | **Git** 사용, `develop` 브랜치에서 기능별 `feature/*`로 작업 후 머지 |

---

## ✏️ **코딩 컨벤션**

- **Tab = 4 spaces** (탭 대신 4칸 스페이스 사용)
- **SnapKit** 사용 시 `makeConstraints`의 변수명은 `$0` 또는 `make`로 통일합니다.


---

## 🔄 **Git 관리 규칙**

### 📂 **브랜치 전략**

- **Main**: 최종 배포 브랜치 (직접 코드 수정 금지)

**Develop**: 기능 통합 브랜치 (직접 코드 수정 금지)

- **Feature/**: 새로운 기능 개발을 위한 브랜치 (이름 예시: `feature/login`, `feature/map`)

### 📋 **Git 커밋 컨벤션**

- **Type**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **Format**: `[Type] Title (짧고 간결한 제목)`
- **Example**: `[feat] 로그인 기능 추가`

### 🛠️ **Git PR 관리**

- 작업 후, **PR을 반드시 생성**하여 코드 리뷰를 받습니다.
- PR 작성 시 **변경 사항 및 스크린샷**을 포함합니다.
- Main과 Develop 브랜치에 직접 푸시하지 않고, 모든 작업은 **PR을 통해 머지**합니다.

---

## 📢 **발표 준비**

- 발표는 팀 전원이 협력하여 준비합니다.
- 발표 자료는 Keynote로 제작
- [키노트 발표 자료](https://www.icloud.com/keynote/0a2XLUVi9CaNaQS_vo8UHI9Pw#kickboard-keynote)

---

## 📈 **진행 상황 모니터링**

- **매일 아침 10시 스크럼** (수요일은 12시에 진행)
- 매일 진행 상황을 체크하고, **Task Manager**에 상태를 업데이트합니다.

---

## 📎 **참고 자료**

- [Kakao 지도 API](https://developers.kakao.com/docs/latest/ko/local/dev-guide)
- [Naver 지도 API](https://developers.naver.com/docs/serviceapi/search/local/local.md)
- [Git 커밋 컨벤션](https://www.notion.so/Develop-Conventions-ea83a5acbe6347febbb9890a8438a8de?pvs=21)
