# agents.md – Flutter 프로젝트용 에이전트 가이드

> **목표** — 에이전트(예: ChatGPT Codex, GitHub Copilot)가 *안정적이고 유지보수 가능한* Flutter 코드를 자동 생성·수정하도록 도와주는 규칙 모음입니다. 모든 규칙은 **주니어 개발자**도 쉽게 이해하고 따를 수 있도록 작성되었습니다.

---

## 1. 기본 원칙

| 항목              | 규칙                                                             | 왜 중요한가?                   |
| --------------- | -------------------------------------------------------------- | ------------------------- |
| **테스트 커버리지**    | 전체 라인 커버리지 **≥ 80 %**                                          | 리팩터링·배포 시 회귀 버그를 최소화하기 위해 |
| **UI / 기능 분리**  | `lib/presentation` (위젯·라우팅) vs `lib/domain` (비즈니스 로직) 디렉터리로 구분 | 테스트 용이성 + 재사용성            |
| **README 업데이트** | 새 기능·명령 추가 시 항상 `README.md` 수정                                 | 온보딩 속도 ↑, 문서 신뢰도 ↑        |
| **커밋 단위**       | "하나의 논리적 변경 == 하나의 커밋"                                         | Git 히스토리 탐색·리버트가 쉬워짐      |
| **PR 필수 체킹**    |  ✅ 빌드 성공  ✅ 테스트 통과  ✅ 커버리지 ≥ 80 %                              | 품질 게이트 역할                 |

---

## 2. 프로젝트 구조

```
lib/
├── presentation/      # UI 레이어 (Stateless/Stateful 위젯, Theme, Router)
│   ├── screens/
│   └── widgets/
├── domain/            # 비즈니스 로직, 엔티티, use‑case
│   ├── models/
│   └── use_cases/
├── data/              # 외부 데이터소스(Firestore, REST, …) 연동 코드
└── utils/             # 공통 헬퍼, 확장 함수

 test/
 ├── presentation/     # 위젯 테스트
 ├── domain/           # 단위(Unit) 테스트
 └── data/             # 통합(Integration) 테스트 또는 Mock 사용
```

> **TIP 🎯** — Agent가 새 파일을 만들 때는 *반드시* 올바른 레이어 디렉터리에 생성하도록 프롬프트에 명시하세요.

---

## 3. 에이전트 워크플로

1. **Issue 작성** : 작업 목적·Acceptance Criteria·테스트 포인트 정의

2. **브랜치 생성** : `feature/<ticket>‑<요약>` 또는 `fix/<ticket>`

3. **Agent 프롬프트** 예시  (기능 추가)

   ```text
   시스템: Flutter v3.22.0, Null‑safety ON, Riverpod 2 사용. lib/presentation vs lib/domain 분리.
   사용자: 숫자 계산 기능을 lib/domain/use_cases/calculate.dart 로 구현하고, 모든 사칙연산 로직을 포함한 Unit Test 를 test/domain/calculate_test.dart 에 작성. 커버리지 90 % 이상 필요.
   ```

4. **코드 생성 & 로컬 테스트 실행**

   ```bash
   flutter test --coverage
   genhtml coverage/lcov.info -o coverage/html  # HTML 리포트 (선택)
   open coverage/html/index.html
   ```

5. **PR 생성** → Self Review → CI 통과 확인 후 Merge

6. ``** 브랜치 Pull && 다음 작업 반복**

---

## 4. 테스트 전략

| 수준              | 프레임워크/도구                       | 목표                    | 예시 디렉터리                 |
| --------------- | ------------------------------ | --------------------- | ----------------------- |
| **Unit**        | `flutter_test` + `mocktail`    | 한 함수·클래스 로직 검증        | `test/domain/...`       |
| **Widget**      | `flutter_test`                 | 위젯 트리 렌더·상호작용 확인      | `test/presentation/...` |
| **Integration** | `integration_test`, `fluttium` | 실제 장치 동작, Firebase 연동 | `integration_test/`     |

> 커버리지는 `lcov.info`를 CI에서 수집해 **Codecov badge**를 `README.md`에 붙입니다.

---

## 5. 코드 품질 체크리스트 (에이전트가 작성한 PR용)

-

> **Rule of Thumb** — 에이전트가 생성한 코드에 TODO/print 문이 남아있으면 실패 처리

---

## 6. CI/CD 예시 (GitHub Actions)

```yaml
# .github/workflows/flutter.yml
name: Flutter CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'
      - run: flutter pub get
      - run: flutter analyze --no-pub
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov.info
          fail_ci_if_error: true
```

---

## 7. 에이전트용 자주 쓰는 명령어 스니펫

| 작업               | 명령어/스니펫                                               |
| ---------------- | ----------------------------------------------------- |
| **패키지 추가**       | `flutter pub add <package>`                           |
| **새 화면 생성**      | `dart run build_runner build` (Freezed, Riverpod gen) |
| **커버리지 리포트 열기**  | `open coverage/html/index.html` (macOS)               |
| **디버그 모드 실행**    | `flutter run –d chrome` 또는 `–d android`               |
| **테스트 한 파일만 실행** | `flutter test test/domain/calculate_test.dart`        |

---

## 8. FAQ (에이전트 프롬프트 팁)

**Q1. 테스트 코드를 깜빡했어! 자동으로 생성할 수 있어?**\
A1. 프롬프트에 \*"테스트 코드와 Mock 데이터 포함"\*을 명시하고, `flutter_test` 예시를 보여주면 정확도가 올라갑니다.

**Q2. UI 코드에서 setState가 많이 쓰이는데, Riverpod을 적용하려면?**\
A2. "StatelessWidget + Consumer" 구조를 기본 템플릿으로 제공하도록 에이전트에 알려주세요.

**Q3. 커버리지 계산이 80 %에 못 미치면?**\
A3. `--coverage` 보고서에서 누락된 라인을 확인 후, 해당 구문을 테스트에서 호출하도록 보강하세요.

---

## 9. 참고 링크

- [Flutter 공식 Testing 文서](https://docs.flutter.dev/testing)
- [Effective Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Codecov Docs – Flutter](https://docs.codecov.com/docs/flutter)
- [Riverpod State Management](https://riverpod.dev)

---

> 마지막 업데이트 : 2025‑06‑25 (Asia/Seoul)

이 가이드는 프로젝트 요구사항에 따라 언제든 수정될 수 있습니다. 변경 시 **PR “Docs/Update agents.md”** 형태로 제출해주세요.

