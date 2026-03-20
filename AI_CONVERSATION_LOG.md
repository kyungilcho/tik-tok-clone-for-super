# AI Conversation Log

아래 내용은 이번 작업 세션의 대화를 `user:` / `codex:` 형식으로 옮긴 기록입니다.  
시스템 export 원문은 아니고, 현재 스레드에 남아 있는 대화 기준으로 정리한 로그입니다.

---

user: [플러터 클라이언트 개발자 (2년 이상) 포지션 과제전형 - TikTok Clone 만들기] Flutter를 사용하여 TikTok 스타일의 숏폼 영상 피드 앱을 구현해 주세요. 이런 과제를 받았아. 가장 먼저 하면 좋을게 뭐야

codex: 가장 먼저 할 일은 UI 꾸미기가 아니라 핵심 기술 스파이크를 만드는 겁니다. 1시간 안에 `PageView`, 현재 페이지만 autoplay, 화면 벗어나면 pause, buffering 표시까지 되는 최소 앱을 먼저 만들어야 합니다.

user: 지금 완전 빈프로젝트인데

codex: 그럼 더 단순합니다. `flutter create .` -> `video_player` 추가 -> `main.dart` 하나로 세로 피드 뼈대를 먼저 구현하면 됩니다.

user: 선택: visibility_detector / 선택: provider 또는 riverpod 이건 이유가 뭔데

codex: `visibility_detector`는 정교한 재생 제어용이고, `provider/riverpod`은 구조 확장용입니다. 지금 빈 프로젝트 단계에서는 둘 다 없이 시작해도 됩니다.

user: 그럼 일단 최초 커밋위주로 정리를 해보자

codex: 좋습니다. `initialize flutter project` -> `starter app 정리` -> `vertical feed scaffold` -> `video playback lifecycle` -> `overlay UI` -> `구조 정리` -> `README` 순서로 커밋을 나누는 게 좋습니다.

user: 1번커밋까지 진행해줘

codex: 첫 커밋까지 완료했습니다. `chore: initialize flutter project`

user: 간단한 디자인이 먼저야 아니면 리드미가 먼저야?

codex: 지금 단계에서는 간단한 디자인이 먼저입니다. README는 실제 구현을 바탕으로 써야 정확합니다.

user: 그럼 그 전에 총망라 계획서를 작성해보고 그거 베이스로 진행하는게 어때

codex: 좋습니다. 무거운 기획서 말고 실행용 계획서를 만들고, 구현 순서와 스텝별 할 일까지 같이 적어두는 방식이 좋습니다.

user: 좋아. 대신 구현 순서와 스텝별 할일 도 적어두자

codex: 실행 계획서를 추가했습니다. 구현 순서, 각 스텝의 목표, 할 일, 완료 조건, 커밋 계획까지 들어가 있습니다.

user: 일단 스타터 앱 제거 하는게 먼저야 아니면 뭐 해야해 이제

codex: 이제는 스타터 앱 제거가 먼저입니다. 기본 counter 예제를 걷어내고 과제용 scaffold로 바꾸는 게 맞습니다.

user: 깨끗하게 제거 해줘

codex: 스타터 앱은 깔끔하게 제거했습니다. 과제용 최소 scaffold와 새 테스트 기준으로 정리했습니다.

user: 스캐폴드는 뭐 베이스로 개발하려고? 디자인부터 한다고 하지 않았어?

codex: 제가 말한 디자인 먼저는 완성형 비주얼이 아니라 과제용 화면 구조를 먼저 잡는다는 뜻이었습니다. 베이스는 TikTok 메인 피드 1장입니다.

user: 스타터 제거 했지 지금?

codex: 네. 스타터 앱 제거는 끝났습니다.

user: 그럼 스캐폴드 붙이려면 디자인을 만들어야 하는거아냥?

codex: 맞습니다. 이제부터는 디자인을 만들어야 합니다. 전체 화면 영상, 하단 메타데이터, 우측 액션 레일, 세로 스와이프를 기준으로 화면 구조를 잡으면 됩니다.

user: 그래도 기왕 하는거 좀 예쁘게 하자. 틱톡화면 분석해서 요구사항에 들어있는(추가점수 포함) 피그마로 뽑아놓는게 어때

codex: 좋은 방향입니다. 다만 메인 피드 1장과 상태 몇 개만 피그마로 고정하는 방식이 적절합니다.

user: 피그마로 생성해봐

codex: 가능합니다. 새 Figma 파일로 만들겠습니다.

user: 새로 만들어줘

codex: 새 Figma 파일을 만들었습니다. 메인 피드와 상태별 화면을 넣었습니다.

user: 영상을 줬으니까 다시 분석해봐. 문서랑 figma 디자인 둘 다 업데이트 되어야할 것 같아. 특히 디자인은 옆에 오버레이 버튽들이 svg아이콘이 필요한데, 하나도 안 만들어져있고, 하트 아이콘도 틱톡과 많이 차이가 있어

codex: 영상 기준으로 다시 분석해서 문서와 Figma를 업데이트했습니다. 오버레이 버튼을 TikTok식 SVG 아이콘 레일로 바꾸고, 상단/하단 구조도 실제 앱 쪽에 가깝게 조정했습니다.

user: 왜 피그마로 오니까 하트 같은 것들이 다 없어지지?

user: 그럼 그냥 피그마에 직접 그리자. icon들 어차피 아이콘들은 디자인 시스템이라 그려둬야해

codex: 맞습니다. 아이콘 전용 보드를 따로 만드는 게 맞습니다. 아이콘 시스템 페이지를 추가했습니다.

user: 그리고 이제 연결해야지

user: 아니 그게 아니고 그 바로 앱에 붙이란 얘기가 아니고, 우리 아이콘 빠져서 들어간 디자인 피그마 쪽에 연결해야한다는 거였어

user: 어

codex: 맞습니다. 피그마 쪽으로 다시 연결했고, 아이콘이 포함된 피드 페이지를 다시 캡처해서 반영했습니다.

user: 그리고 not interested, interested 버튼도 필요 없을 것 같아. 위에 notifiaction부분도 필요 없고, 코인 아이콘도 필요 없어 과제 기획상

codex: 과제 범위 밖 요소들은 제거했습니다.

user: 두번째이미지가 틱톡 진짜 버튼이고 첫번째가 네가 만든건데, 틱톡 진짜에ㅐ 가깝게 수정해줘

codex: create 버튼을 더 실제 TikTok에 가깝게 수정했습니다.

user: 미세 조정은 됐고, 이제 필요한 내용만 나눠서 커밋하고 개발 진행하면 되지 않을까

codex: 네. 지금은 `starter scaffold`, `docs`, `design source` 정도로 나눠 커밋하면 됩니다.

user: 일단 1번 먼저 해줘. 그리고 docs는 올리지 않으려고

codex: `chore: replace starter app with assignment scaffold` 커밋만 처리했습니다. docs는 올리지 않았습니다.

user: 디자인은 커밋을 하자

codex: 디자인 쪽도 정리됐고, 그대로 개발 단계로 넘어갈 수 있습니다.

user: 다음 뭐부터 하는게 좋을까

codex: 다음은 디자인 커밋을 하고 바로 `vertical video feed scaffold`로 가는 게 좋습니다.

user: 디자인 커밋을 한번 하자

codex: 디자인 커밋 완료했습니다. `design: add feed mockup and icon system sources`

user: 좋아 진행해

codex: `vertical feed scaffold`까지 구현하고 커밋했습니다.

user: 파일구조 잡으면서 launch.json 하나만 만들어줄래

codex: `.vscode/launch.json` 추가했습니다.

user: 아 이건 필요 없어 안 올려도 돼

codex: `.vscode/launch.json`은 제거했습니다.

user: portrait up으로 고정을 해야할 것 같아

codex: 세로 고정을 적용했습니다.

user: 아니 그리고 바텀네비게이션을 고정돼야하는데, 바텀네비게이션을 화면에 붙여두면 어떡해

user: 아니지 앱네비게이터에 바텀네비게이션을 걸면 알아서 잡혀

codex: 바텀 네비를 `Scaffold.bottomNavigationBar` 쪽으로 옮겼습니다.

user: 생각해보면 확장성있게 만들라고 했으니까, appshell을 만들고, 쉘의 브랜치 중에서 하나가 home이고 홈의 탭중 하나가 피드인 구조로 가야해. 나머지는 미구현 placeholder로 두고

codex: 그 방향으로 구조를 바꿨습니다. `AppShell -> Home -> FeedTab` 구조입니다.

user: 커밋을 한번 잡고 가는게 좋지 않겠어?

codex: `orientation lock`과 `app shell 구조 도입`을 커밋으로 끊었습니다.

user: 좋아 진행해줘

user: 아니 지금 근데 아직 영상을 연결한건 아니지? feed화면에

codex: 코드 기준으로는 연결해둔 상태입니다. 다만 실제 화면에서 재생 확인은 아직 안 했습니다.

user: 코드상으로 영상이 나와야해?

codex: 네. 지금 코드상으로는 feed 화면에서 영상이 나와야 맞습니다.

user: 안나오는데

codex: 초기화 실패 시 에러 상태를 보이도록 수정했습니다. plugin 추가 직후라 hot reload가 아니라 콜드 스타트가 필요합니다.

user: UnimplementedError: init() has not been implemented

codex: plugin이 현재 실행 앱에 아직 안 붙은 상태일 가능성이 큽니다. 앱을 완전히 종료하고 다시 실행해야 합니다.

user: 콜드 스타트 하니까 되네

codex: 원인은 맞았습니다. plugin 등록 문제였습니다.

user: 좋아. 두번에 나눠서 해줘. 패키지 추가(pubsepc+xml+plist 등) / 기능 추가 이런 식으로

codex: 두 커밋으로 나눠 정리했습니다. `video_player` 플랫폼 설정과 실제 playback lifecycle을 분리했습니다.

user: 자 다음은 뭐지

codex: 다음은 좋아요 인터랙션이나 상태관리 정리 단계가 좋습니다.

user: 상태를 먼저 잡고 가는게 나으려나?

codex: 네. 지금 시점이면 상태를 먼저 잡고 가는 게 맞습니다.

user: 확장성 생각하면 bloc이 낫지 않나?

codex: 과제 설명력만 보면 Bloc이 더 설득력 있을 수 있지만, 실제 제품 기준 기본 선택은 Riverpod이 더 낫다고 봅니다.

user: 만약에 진짜 이게 과제가 아니고 그냥 앱을 개발하는거라면 어떤 상태관리자가 가장 맞을까?

codex: 실제 앱이라면 전체 기본 상태관리는 Riverpod, 일부 복잡한 워크플로우만 Bloc이 맞습니다.

user: 그러면 riverpod + riverpod generator랑 순수 리버팟 둘중에서는?

codex: 지금 프로젝트 단계에서는 순수 Riverpod이 더 낫습니다.

user: 그럼 리버팟 설계는 어떤 식으로 할건지 문서에 정리해봐

codex: Riverpod 설계 문서를 정리했습니다.

user: 프로바이더를 제낀이유도 추가하자

codex: `Why Not Provider` 섹션을 추가했습니다.

user: like current page infinitescroll 같은 애들은 viewmodel화 하는게 낫지 않나. 완전 중앙보다

codex: 네. `FeedViewModel/FeedNotifier` 같은 feature-scoped 상태가 더 맞습니다.

user: 근데 사실 feedpage에 붙는데이터잖아? like나 코멘트 개수 이런 애들은?

codex: 화면에는 `FeedPage`에 붙지만, 상태 소유는 `Feed feature state`가 하는 게 맞습니다.

user: 그럼 한번 플로우로 그려볼래

codex: `FeedPage가 이벤트를 받고, FeedViewModel이 상태를 바꾸고, FeedPage가 다시 그린다`는 구조로 플로우를 설명했습니다.

user: 리버팟은 원래 ui를 한번 거치나? tap 콜백 안에서 바로 처리 못하고?

codex: tap 콜백 안에서 바로 처리합니다. 다만 UI가 상태를 직접 바꾸지 않고 provider/notifier에 위임합니다.

user: 아 결국 나랑 너랑 같은 말을 하는거였구나?

codex: 네. 같은 얘기였습니다.

user: 좋아 그럼 한번 문서 다듬어줘

codex: 문서를 `feed feature scoped viewmodel` 표현으로 다시 정리했습니다.

user: 진행하자

codex: Riverpod 전환까지 붙였습니다.

user: 지금 좀 이상해졌어. 지금 영상 세개라 두번 아래로 내리면 더 못내려야하는데, 계속 내릴 수 있어

codex: 원인은 mock pagination이 먼저 켜져 있었기 때문입니다. 우선 고정 3개로 막았습니다.

user: 근데, 틱톡은 infinite scroll이야?

codex: 실제 TikTok 메인 피드는 사실상 infinite scroll에 가깝습니다.

user: 근데 infinite scroll이라고 하면 새롭게 무언가가 로딩이 되어야하는데, 지금은 그냥 루프에 가깝지 않아?

codex: 맞습니다. 지금은 mock append일 뿐이고 UX상으로는 루프에 가깝습니다.

user: 좋아 그렇게 해보자

codex: 페이지별로 다른 mock 세트를 로드하도록 바꿨습니다.

user: 좋아. 여태까지 수정한거 커밋 계획이 어떻게돼. 아직 커밋을 한번도 안 했어

codex: Riverpod 도입, feed state 이관, mock pagination 3덩어리로 나눠 커밋하는 계획을 제안했습니다.

user: 커밋해줘

codex: 두 커밋으로 정리했습니다. `provider scope`, `feed state to riverpod notifier`

user: 자 다음은 뭐지

codex: 다음은 lifecycle 마감, notifier 테스트, overlay 잔기능, README 정리 순서가 좋습니다.

user: 근데 좋아요 토글 기능이 안 됐는데?

user: 그 아이콘 버튼(오버레이들) 뒤에 쉐도우를 조금 깔아야할 것 같아. 배경이 하야면 하나도 안 보여

codex: 우측 액션 레일 오버레이에 전체적인 섀도우를 넣었습니다.

user: 쉐도우가 지금 아래만 들어가있는데, 전체적으로 들어가게 바꿔줘

codex: 전체적으로 퍼지는 섀도우로 바꿨습니다.

user: 그리고 지금 더블탭시 하트가 센터에만 뜨는데, 더블탭한 지점에 넣어줘

codex: 더블탭 위치에 하트가 뜨도록 바꿨습니다.

user: 그리고 저 좌측 상단에 시간 표시는 불필요하니까 없애줘

codex: 좌측 상단 시간 표시는 제거했습니다.

user: 그리고 Liked on Double tap 이거 뜨는것도 없애줘

codex: `Liked on double tap` 토스트는 제거했습니다.

user: pause badge도 틱톡은 우리가 아까 아이콘 버튼 디자인 잡은거랑 동일하게 잡혀있어. 투명 배경에 쉐도우, 화이트 플레이아이콘만. 서클이나 이런거 없고

codex: pause badge를 그 방향으로 바꿨습니다.

user: 지금 구현 안 한게 뭐지

codex: 핵심 필수 요구사항은 거의 다 들어가 있고, 실제 미구현은 placeholder 탭, 실제 서버 연동, lifecycle 보강, README/제출물 정리 정도입니다.

user: 과제 요구사항 중에서는?

codex: 필수 요구사항과 가산점 핵심은 거의 충족 상태입니다.

user: 내가봤을때, 그걸 해야할것 같은데, mockdata에 지금 그거밖에 없지? 비디오 url 나머지는 다 하드코딩이지?

codex: 맞습니다. 지금은 mock pagination 구조만 있고 데이터 자체는 전부 하드코딩입니다.

user: json 계층으로 분리를 하고, json에 videourl, liked numbers, liked or not, comment number, bookmarked number, shared number, original track image & id, info of account who posted this video, 가 들어가야하지 않을까?

codex: 네. 과제 기준으로는 로컬 JSON fixture로 분리하는 게 맞고, 지금 말한 수준의 메타데이터가 들어가는 게 설득력 있습니다.

user: 교체를 하는게 의미가 있나 과제에서

codex: 과제에서는 실제 API 교체 자체보다 교체 가능하게 설계했다는 점이 중요합니다.

user: 그래 그럼 json fixture까지만 짜자

codex: JSON fixture 기반으로 바꿨습니다.

user: json에 어카운트 아바타 이미지를 받아와서 avataraction에 클립해서 넣도록 해주고, original track도 필요할 것 같아. 그리고 비디오도 thumbnail 도 받아와야하지 않아?

codex: avatar, original track, thumbnail까지 실제 화면에 반영했습니다.

user: 비디오에서 잘리는 부분은 없는거지?

codex: 현재는 화면을 꽉 채우는 방향이라 일부 크롭은 생길 수 있습니다.

user: 보면 이런 영상들이 있던데

codex: 가로형이나 정사각형에 가까운 영상은 `contain`, 세로형은 `cover`로 처리하도록 바꿨습니다.

user: 플레이스 홀더를 넣고 싶어. 배경 없는 틱톡 로고로 대신 컬러 죽이고 그레이톤으로 지금 있는 placeholder는 없애줘

codex: placeholder 화면을 회색 톤 TikTok 로고 기반으로 바꿨습니다.

user: 인터넷이 너무 느려서 blurred thumbnail을 못받아오면, 방금 만든걸 쓰고, thumbnail을 받아오면 thumbnail을 쓰고 이런식으로 가능ㅎ나가

codex: 가능합니다. 기본 placeholder -> thumbnail 로드 성공 시 fade in 구조로 만들 수 있습니다.

user: 그럼 지금 시작때 뜨는 배경은 뭐야

codex: 지금은 thumbnail + gradient + glow + figure가 섞인 커스텀 placeholder입니다.

user: fallback도 tiktok로고로 해줘

codex: fallback도 TikTok 로고로 바꿨습니다.

user: thumbnail을 너가 만들었어? 진짜 이미지 url의 썸네일이 아닌거 같은데

codex: 맞습니다. 지금 `thumbnailUrl`은 임시 이미지였습니다.

user: 2으로 하자

user: 근데 가장 앞프레임 캡쳐로 하면 어때?

codex: 과제용으로는 괜찮고, 0.0초보다는 0.3초 정도의 meaningful first frame이 더 안전합니다.

user: 그럼 첨 meaningful fram으로 가자

codex: 실제 mp4에서 뽑은 poster asset으로 바꿨습니다.

user: 아니 영상이 cover면 이미지도 cover고 영상이 contain이면 이미지도 contain이어야지 두개가 안 맞으니까 이상하잖아

codex: poster와 video가 같은 fit 규칙을 쓰도록 맞췄습니다.

user: 여전히 똑같은데, 뭔가 비율이 다르게 추출됐나?

codex: poster 문제가 아니라 fixture의 aspectRatio가 잘못 들어가 있었습니다. 실제 값으로 고쳤습니다.

user: 너무 그리고 다 가로가 긴 비디오들만 있네, 세로가 긴 틱톡 영상들로 절반정도 교체 가능할까?

codex: 가능하고, 앞쪽 절반은 세로형 클립으로 바꾸는 게 좋습니다.

user: 진행해줘 교체 작업 그리고 지금 3 3 3 이잖아? 한세트 정도 더추가해줘ㅏ

codex: 세로형 클립 위주로 교체하고, 4번째 세트까지 추가해서 총 12개로 늘렸습니다.

user: 그리고 틱톡 보니까 영상이 재생 중에 네트워크가 느려서 버퍼링이걸리면 이런식으로 아래 리니어한 인디케이터가 펄스형으로 움직이는 애니메이션이 들어가던데, 우리 영상이 다 너무 화질이 낮은지 속도 제한을 해도 버퍼링이 안걸리네

codex: 재생 중 버퍼링은 하단의 얇은 리니어 펄스 바로 바꿨고, 디버그 빌드에서는 long press로 강제 표시되게 해뒀습니다.

user: https://vt.tiktok.com/ZSuHqYnwK/ 이것도 추가 가능한가?

codex: 추출은 가능하지만 signed temporary URL이라 그대로는 불안정합니다.

user: 아니야 그렇게까지 굳이

codex: 그럼 넣지 않는 게 맞습니다.

user: 우리가 넣은 영상 화질들은 어때?

codex: 몇 개는 낮고, 특히 특정 horizontal sample은 교체 추천이라고 정리했습니다.

user: 조금 더 고품질료 교체해줘

user: 아니 근데 동영상 에셋을 우리 로컬에 저장하고 불러오는거였어? network에서 불러오는게 아니고?

codex: 그 시점에는 local 6 + network 6 혼합 상태였고, 네트워크 처리 어필을 위해 전부 network video로 다시 정리하는 게 맞다고 설명했습니다.

user: 아니 네트워크로 해야해 그래야 network처리를 보여주지

codex: 맞습니다. 그래서 video는 전부 network로 다시 정리했습니다. poster만 local로 남겼습니다.

user: 혹시 이런거 개발하는 용도의 메타데이터도 모아둔 그런 테스트용 스토리지 같은 거 있나?

codex: Pixabay, Pexels, Apple HLS example 같은 선택지를 설명했습니다.

user: Pixabay로 한번 해보자

user: 아 가입을 해야하는건 별로야 전으로 돌려줘

codex: 실제 Pixabay 전환은 안 들어갔기 때문에 되돌릴 코드는 없습니다.

user: 근데 왜 버퍼링이 안 걸리지

codex: 다음 페이지 preload, 짧고 가벼운 MP4, 플레이어 내부 버퍼 때문에 재생 중 rebuffer가 잘 안 나는 구조라고 설명했습니다.

user: 아니 나 안드로이드 개발자도구에서 걸었는데

codex: throttling은 맞고, preload가 잘 먹혀서 버퍼링이 잘 안 보이는 쪽이라고 설명했습니다.

user: offscreen initailze는 근데 저거때문에 넣은거 아냐? 최적화?

codex: 맞습니다. 체감 최적화입니다.

user: 아 여기에 하지 말고 파일로 써줘

codex: 대화 로그는 파일로 따로 쓰겠습니다.

user: 지금 screen이 코드가 너무 긴거 같은데

codex: `feed_page.dart`가 너무 커져서, lifecycle/gesture만 남기고 배경/오버레이/액션 레일/메타데이터/프로그레스 UI를 분리하겠습니다.

user: feed_page.dart에 children에 너무 리스트가 길어. 부분별로 나눠야 가독성이나 유지보수성이 늘어날 것 같아

codex: 맞습니다. `Stack(children)`도 `video layers`, `status overlays`, `action rail`, `metadata`, `progress` 조립 단위로 나누겠습니다.

user: 커밋한번 해줘

codex: `refactor: split feed page presentation widgets`로 커밋했습니다.

user: 영상 분석해서 지금 아바타, comment, share, music 쪽이 인터렉션 자체가 unimplemented 상태잖아? interaction이랑 거기서 나오는 ui(page, bottomsheet)는 껍데기를 만들어서 넣고, unimplemented 처리해줘

codex: 레퍼런스 영상을 보고 댓글/공유/사운드 bottom sheet, 아바타 프로필 페이지 형태의 shell UI를 붙이겠습니다. 기능은 `Prototype / unimplemented`로 명시하겠습니다.

user: bottomsheet들 전부 tapout side 시 hide 잡아주고, 지금 60~70프로정도 차오르는데 50프로정도로 줄여줘

codex: 바깥 탭 dismiss를 명시하고, 공통 프레임 높이도 낮추겠습니다.

user: 아니다 지금 보니까 코멘트랑 오리지널 트랙은 높아도 되고, share는 내부 사이즈에 맞게 나오게 잡아줘

codex: 댓글/오리지널 트랙은 큰 시트로 유지하고, 공유만 콘텐츠 높이 기반으로 바꾸겠습니다.

user: share가 안 닫혀 그리고 dismiss가 안 되는데?

codex: 공유 시트만 공통 프레임을 안 타는 별도 `Material` 시트로 다시 바꿔 dismiss를 확실히 복구하겠습니다.

user: 여기까지 커밋해줘

codex: `feat: add feed interaction shell surfaces`로 커밋했습니다.

user: 너와의 대화 내용을 좀 추출할 수 있을까

codex: 시스템 원문 export는 못 하지만, 제출용 로그는 재구성할 수 있다고 설명했습니다.

user: raw한 로그가 필요한데

codex: 진짜 시스템 원문 덤프는 못 하고, `user:` / `codex:` 형식의 raw 스타일 재구성 로그는 만들 수 있다고 답했습니다.

user: 덤프 하지 말고, 그냥 user: codex: 형식으로 우리가 했던 대화 내용만 쭉 그대로 적어볼래?

codex: 가능하다고 답했고, 이후 파일로 정리하는 방향으로 이어졌습니다.

user: 아 여기에 하지 말고 파일로 써줘

codex: 파일로 따로 작성하겠다고 했고, 이 문서를 생성했습니다.
