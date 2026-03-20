# TikTok Clone

TikTok 스타일의 숏폼 영상 피드를 Flutter로 구현한 프로젝트입니다.
세로 스와이프 피드, 현재 페이지 자동 재생, off-screen pause, 오버레이 UI, 좋아요/북마크 인터랙션, drag-to-seek progress bar, mock pagination까지 포함하고 있습니다.

이 저장소는 Flutter 클라이언트 과제 구현을 위해 만들었지만, README는 과제 답안지보다 일반적인 프로젝트 문서에 가깝게 정리했습니다.

## Overview

이 앱은 `For You` 스타일의 세로 영상 피드를 중심으로 구성되어 있습니다.

- `PageView.builder` 기반 vertical feed
- 현재 페이지 autoplay
- 화면을 벗어난 페이지 pause
- drag-to-seek progress bar
- 탭/브랜치 구조를 가진 app shell
- JSON fixture 기반 feed metadata
- public network MP4 기반 video playback
- Riverpod 기반 feed state 관리
- action rail interaction shell UI

현재 구현은 feed 중심이며, 나머지 탭은 placeholder로 유지하고 있습니다.

## Features

### Core

- Vertical video feed
- Current page autoplay
- Off-screen pause
- Tap to pause / resume
- Drag to seek
- Auto-hide progress bar
- Initial loading indicator
- In-play buffering indicator
- Overlay UI
  - top tabs
  - right action rail
  - bottom metadata
  - bottom navigation

### Interaction

- Like toggle
- Double tap like
- Bookmark toggle
- Like / bookmark micro-animation
- Action rail tap isolation from playback gesture
- Pause indicator
- Avatar / comment / share / music interaction shell surfaces
- Debug buffering trigger for local verification

### Data / State

- JSON fixture based metadata
- Public video URL playback
- Local poster image fallback
- Mock pagination
- Riverpod based feed state

## Tech Stack

- Flutter
- `video_player`
- `flutter_riverpod`
- `cupertino_icons`

## Getting Started

### Requirements

- Flutter SDK
- Network access for video playback

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Run tests

```bash
flutter test
```

## Runtime Notes

- Video streams are loaded from public network MP4 URLs.
- Feed metadata is loaded from `assets/fixtures/feed/*.json`.
- Poster images are loaded from `assets/posters/feed/`.
- The app is locked to `portraitUp`.
- Video progress can be scrubbed on the active page.

## Project Structure

```text
lib/
  app.dart
  main.dart
  features/
    app_shell/
      presentation/
        screens/
        widgets/
    home/
      presentation/
        screens/
    feed/
      application/
      data/
      domain/
      presentation/
        screens/
        video/
        widgets/
    shared/
      presentation/
        widgets/

assets/
  fixtures/
    feed/
  posters/
    feed/
```

## Architecture

### AppShell

앱의 최상위 navigation branch를 관리합니다.

- `Home`
- `Friends`
- `Create`
- `Inbox`
- `Profile`

현재는 `Home`만 실제 기능이 있고, 나머지는 placeholder입니다.

### Home

Home 내부 탭을 관리합니다.

- `Explore`
- `Following`
- `For You`

현재 실제 구현은 `For You` feed입니다.

### Feed

숏폼 피드 기능을 담고 있는 feature입니다.

- `data`
  - repository
  - fixture loading
- `domain`
  - feed item model
  - repository contract
- `application`
  - Riverpod notifier / state / providers
- `presentation`
  - feed screen
  - page widget
  - video controller adapter
  - split presentation widgets
    - background
    - overlays
    - action rail
    - metadata
    - progress bar

## Feed Data Model

Feed item은 단순한 video URL 하나만 가지지 않고, UI에 필요한 정보를 같이 포함합니다.

- author
- track
- video
- caption
- metrics
- interaction
- visual

즉, 지금은 mock data이지만 실제 API DTO로 확장하기 쉬운 형태를 유지하려고 했습니다.

## Playback Lifecycle

각 `FeedPage`는 자신의 `VideoPlayerController`를 가집니다.

- page 생성 시 controller initialize
- active page일 때만 play
- 비활성 page는 pause
- page dispose 시 controller dispose

또한 player state를 구독해서 다음 상태를 UI에 반영합니다.

- initial loading
- buffering
- error
- manual pause
- current playback position / duration

그리고 progress bar는 active page에서만 노출되며, 사용자가 drag 해서 seek할 수 있습니다.

## State Management

feed 상태는 Riverpod으로 관리합니다.

Riverpod이 맡는 상태:

- feed item 목록
- current page index
- like 상태
- bookmark 상태
- pagination
- loading / error

widget local state가 맡는 상태:

- `VideoPlayerController`
- pause/resume 일시 상태
- double tap heart animation
- progress bar visibility / scrub position
- debug buffering pulse

즉, feed business state와 player lifecycle state를 분리하는 방향으로 구성했습니다.

## Pagination

feed는 mock pagination 구조를 사용합니다.

- 처음에는 첫 페이지를 로드
- 마지막 근처까지 도달하면 다음 fixture page를 append
- fixture가 더 이상 없으면 pagination 종료

실제 API 연동은 아직 없지만, repository 인터페이스를 분리해 두었기 때문에 remote data source로 교체하기 쉬운 구조입니다.

## Current Status

구현 완료:

- vertical feed
- current page autoplay
- off-screen pause
- overlay UI
- like toggle
- bookmark toggle
- double tap like
- drag-to-seek progress bar
- buffering UI
- mock pagination
- Riverpod 기반 상태관리
- action rail animation
- avatar / comment / share / music shell UI

아직 placeholder인 부분:

- `Explore`
- `Following`
- `Friends`
- `Create`
- `Inbox`
- `Profile`
- profile / comment / share / music의 실제 데이터 연동
- comment 작성 / share intent / sound detail / follow 같은 실제 액션

## Notes for Future Expansion

실서비스로 확장한다면 아래 작업이 필요합니다.

- current / next / previous page 기준의 preload 정책
- HLS/DASH 기반 adaptive bitrate
- feed API / cursor pagination
- image / video cache 전략
- background / foreground lifecycle 대응
- playback analytics / logging
- feature 단위 상태 분리 강화

---

## Assignment Appendix

아래 내용은 과제 제출 요구사항에 맞춰 별도로 정리한 항목입니다.

### Demo Video

[Simulator Screen Recording - iPhone 17 - 2026-03-20 at 10.51.07.mp4](Simulator%20Screen%20Recording%20-%20iPhone%2017%20-%202026-03-20%20at%2010.51.07.mp4)

### Q1. 앱 구조 설계

#### 폴더 구조 설계 이유

처음에는 단일 화면으로 빠르게 시작했지만, 과제에서 `확장 가능한 구조`를 중요하게 볼 가능성이 높다고 판단해서 `AppShell -> Home -> Feed` 구조로 정리했습니다.

- `AppShell`
  - 앱 전체 branch를 담당
- `Home`
  - Home 내부 탭 상태를 담당
- `Feed`
  - 실제 숏폼 피드 기능을 담당

이 구조를 선택한 이유는 navigation과 feed 기능을 분리해서, 이후 기능이 늘어나도 역할이 섞이지 않도록 하기 위해서였습니다.

#### 상태 관리 방식 선택 이유

상태 관리는 `Riverpod`를 사용했습니다.

이 앱은 단순한 페이지 전환만 있는 것이 아니라,

- feed item 목록
- 현재 page index
- like 상태
- pagination
- loading / error

를 함께 관리해야 합니다. 이걸 전부 widget local state로 처리하면 화면과 상태가 강하게 결합되고, 반대로 전역 상태로 모두 끌어올리면 과도해집니다.

그래서 `feed feature scoped state`라는 기준으로 정리했습니다.

- `Riverpod`
  - feed 목록
  - current index
  - like
  - pagination
  - loading / error
- `FeedPage local state`
  - `VideoPlayerController`
  - pause/resume
  - double tap animation
  - debug buffering state

#### Video player lifecycle 처리 방식

각 `FeedPage`가 자신의 `VideoPlayerController`를 소유합니다.

- `initState()`에서 controller 생성 및 initialize
- active page일 때만 play
- 화면을 벗어나면 pause
- dispose 시 controller dispose

그리고 `video_player` state를 구독해서 로딩, 버퍼링, 에러, 일시정지 UI를 보여주도록 했습니다.

### Q2. 이 앱을 실제 TikTok 규모 서비스로 확장해야 한다면?

#### video preload 전략

지금은 과제 구현 범위 안에서 부드러운 UX를 우선했습니다. 실서비스라면 다음처럼 더 세밀한 preload 정책이 필요합니다.

- 현재 페이지는 즉시 initialize + play
- 다음 1개는 preload
- 이전 페이지들은 pause 후 dispose
- 네트워크 상황에 따라 preload 강도 조절

#### 네트워크 처리

현재는 `JSON fixture + public MP4` 구조입니다. 실서비스에서는 다음 구조가 필요합니다.

- `FeedRemoteDataSource`
- `FeedRepository`
- cursor 기반 pagination
- retry / timeout / cache 정책
- HLS/DASH 기반 adaptive bitrate
- 네트워크 품질이 떨어질 때 더 낮은 bitrate rendition으로 자동 전환하는 QoE 중심 재생 전략
- startup 시점에는 낮은 화질로 빠르게 재생을 시작하고, 네트워크가 안정되면 점진적으로 화질을 올리는 방식
- like / comment / bookmark / share count에 대한 optimistic update
- 서버 기준 count 정합성을 맞추기 위한 reconciliation 처리
- comment / reaction / share count 변경을 반영하는 websocket 또는 socket 기반 realtime subscription
- comment / profile / share / music action용 별도 data source

특히 숏폼 서비스에서는 좋아요, 댓글, 북마크, 공유 수치가 정적인 값이 아니라 계속 변할 수 있기 때문에, 단순 REST polling만으로는 부족합니다. 사용자가 직접 누른 액션은 먼저 optimistic update로 즉시 반영하고, 이후 서버 응답과 맞춰 보정해야 합니다. 동시에 다른 사용자의 반응 변화는 websocket 같은 실시간 채널로 구독해서 feed item count를 갱신하는 구조가 필요합니다.

현재 프로젝트는 단일 public MP4를 재생하는 구조이기 때문에, 네트워크 상태가 약해졌을 때 화질을 낮춰 재생을 유지하는 기능은 없습니다. 실제 서비스라면 단일 MP4 대신 bitrate ladder가 포함된 HLS/DASH 스트림을 사용하고, 플레이어가 현재 bandwidth와 buffer 상태를 기준으로 자동으로 화질을 조절하도록 설계하는 것이 맞습니다. 이렇게 해야 약한 네트워크에서도 영상이 완전히 멈추기보다 화질을 낮춰서 재생을 이어갈 수 있습니다.

또한 네트워크 계층과 별개로, 플레이어에서 발생하는 시청 이벤트를 데이터 수집 파이프라인으로 보내는 구조도 필요합니다. 예를 들어 사용자가 몇 초까지 시청했는지, 어떤 구간에서 반복 재생했는지, 어느 시점에서 바로 넘겼는지, 버퍼링이 발생한 뒤 이탈했는지 같은 데이터는 추천 품질과 player QoE를 같이 개선하는 데 중요합니다.

#### 상태 관리 구조

현재는 feed 중심 구조라 Riverpod 하나로 충분하지만, 실제 서비스 규모에서는 아래처럼 feature 단위 분리가 더 필요합니다.

- `feed`
- `comment`
- `profile`
- `inbox`
- `upload`
- `auth`

#### 성능 최적화

- offscreen controller dispose 정책
- image / video cache 전략
- adaptive bitrate 및 buffer-aware quality switching
- app lifecycle 대응
- view-through / rewatch / drop-off / buffering 이탈 구간 추적
- jank / memory profiling
- analytics / logging

#### 사용자 데이터 트래킹

숏폼 피드에서는 단순 재생 수보다 `어디까지 봤는지`가 더 중요합니다. 실제 서비스라면 아래 이벤트를 수집해야 합니다.

- impression
- autoplay start
- first frame rendered
- watch duration
- completion rate
- drop-off timestamp
- rewatch / seek / pause
- like / comment / bookmark / share conversion
- buffering 발생 시점과 이탈 여부

이 데이터가 쌓여야 다음과 같은 개선이 가능합니다.

- 추천 모델에서 짧은 이탈과 완시청을 구분
- 특정 구간에서 반복적으로 이탈하는 영상 탐지
- 버퍼링이 engagement 저하로 이어지는지 분석
- 크리에이터 / 영상 / 네트워크 환경별 QoE 비교

#### 관측성

실서비스에서는 기능이 돌아가는 것만으로는 부족하고, 재생 품질과 장애를 계속 관찰할 수 있어야 합니다. 최소한 아래 지표는 모니터링 대상이 되어야 합니다.

- crash rate
- video playback error rate
- buffering rate
- first frame time
- autoplay success rate
- API latency
- pagination failure rate

이런 지표가 있어야 특정 OS 버전, 네트워크 환경, 영상 포맷에서 문제가 발생했을 때 빠르게 감지하고 대응할 수 있습니다.

#### 데이터 정합성

좋아요, 댓글, 북마크, 공유 수치는 사용자가 누르는 즉시 반응하는 것이 중요해서 optimistic update가 필요하지만, 그것만으로 끝나면 정합성이 깨질 수 있습니다. 실서비스에서는 아래 처리가 함께 필요합니다.

- 요청 실패 시 rollback
- 중복 탭 / 중복 요청 방지
- idempotency key 기반 중복 처리
- 서버 응답 기준 최종 count 보정
- 여러 디바이스에서 동시에 발생한 상태 변경 reconcile

즉 클라이언트는 빠르게 반응하되, 최종 상태는 서버 기준으로 다시 맞추는 구조가 필요합니다.

### Q3. 구현 과정에서 가장 어려웠던 문제

가장 어려웠던 부분은 `PageView 기반 feed에서 video lifecycle을 안정적으로 관리하는 것`이었습니다.

구현 중에는 다음 조건을 동시에 만족해야 했습니다.

- 현재 페이지만 autoplay
- 화면을 벗어나면 pause
- 빠르게 swipe해도 controller가 꼬이지 않을 것
- buffering / error / pause UI가 같은 레이아웃 위에서 안정적으로 동작할 것

처음에는 재생 관련 로직이 화면 쪽 state에 많이 섞여 있었는데, 그렇게 두면 page index, like 상태, pagination, player lifecycle이 한 군데에 모이면서 빠르게 복잡해졌습니다.

최종적으로는 다음처럼 역할을 나눠 해결했습니다.

- `FeedNotifier`
  - feed 목록
  - current index
  - like
  - bookmark
  - pagination
- `FeedPage`
  - 영상 한 장의 lifecycle
  - page 단위 interaction state
- `FeedVideoController`
  - `video_player` adapter

이후에는 액션 레일을 별도 위젯으로 다시 분리하고, 댓글/공유/음악 버튼은 실제 기능 대신 shell UI를 먼저 붙여서 흐름을 보이도록 정리했습니다.

### AI Usage

#### AI 사용 여부

사용했습니다.

#### AI를 사용한 작업 범위

- 초기 구현 계획 정리
- 구조 설계 대안 비교
- Riverpod 적용 방향 정리
- UI 수정 방향 논의
- video lifecycle / buffering 디버깅 보조
- interaction shell 구조 정리
- README 초안 작성 보조

AI는 주로 구현 속도를 높이기 위한 pair-programming 보조 도구로 사용했습니다.
구조 대안 비교, 반복적인 UI 분리, README 초안 작성처럼 생산성을 높이는 작업에 활용했고, 최종 방향 결정과 세부 조정은 직접 진행했습니다.

#### 본인이 직접 작성한 부분

- 요구사항 해석과 우선순위 결정
- 앱 구조 선택
- TikTok 레퍼런스를 기준으로 한 UI 방향 조정
- 레퍼런스 영상/화면을 보면서 액션 레일, 버튼 형태, bottom sheet 흐름 같은 디테일 수정 방향 결정
- feed state / player lifecycle 분리 기준 결정
- mock data / pagination 방향 결정
- fixture 구조에 어떤 메타데이터가 들어가야 하는지 정의
- network video, poster asset, interaction shell 범위 같은 구현 단위 결정
- action rail interaction 동작 범위 결정
- README의 확장성 항목에 어떤 실서비스 관점을 넣을지 결정
- 최종 검증과 세부 수정

#### AI 코드 에이전트와의 대화 기록

이번 프로젝트는 OpenAI Codex 기반 코드 에이전트와의 대화를 활용해 진행했습니다.

- 사용 도구
  - Codex / ChatGPT 계열 코드 에이전트
- 제출 방식
  - 저장소에 포함한 대화 로그 문서 첨부

[AI_CONVERSATION_LOG.md](AI_CONVERSATION_LOG.md)
