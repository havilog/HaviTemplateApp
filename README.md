# HaviTemplateApp

참고 깃허브: [갓소네님 TemplateApp](https://github.com/minsOne/iOSApplicationTemplate)

# 계층 구조

![image](https://github.com/hansangjin96/HaviTemplateApp/blob/main/graph.png)

Features의 경우 하위 모듈로 화면 단위 모듈이 추가되어야함.

# 모듈화를 통해 얻는 효과

1. 앱 개발자의 결과물은 화면이고, 화면을 빠르게 개발하기 위해서는 화면 단위의 개발이 필요하다.
따라서 화면 모듈만 빠르게 빌드하고 개발할 수 있다.

2. 도메인 별로 코드를 관리할 수 있다. 따라서 테스트 코드 작성에도 용이해지고 빌드시간도 줄어든다.

3. 개발자마다 각자 맡은 모듈을 개발하여 협업에 용이하다.

등등의 장점이 있다.

# tuist를 사용하는 이유

가장 큰 이유는 프로젝트, framework등에 대한 설정을 템플릿화 해서 빠른 생성을 하기 위함이다.

또 다른 이유로는 `.xcodeproj`파일을 git에 올리지 않음으로 merge conflict를 방지한다.

`xcodegen`같은 도구도 있지만 .swift파일로 관리하고 싶고, 기능적인 지원도 tuist가 더 많기 때문에 tuist를 선택하게 되었다.

[tuist에 관련한 내 블로그](https://velog.io/@hansangjin96/%ED%98%91%EC%97%85-Tuist%EB%A1%9C-.xcodeproj-%EB%A8%B8%EC%A7%80-%EC%BB%A8%ED%94%8C%EB%A6%AD%ED%8A%B8-%ED%95%B4%EA%B2%B0%ED%95%98%EA%B8%B0)

