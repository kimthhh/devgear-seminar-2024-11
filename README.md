
# Delphi + OAuth 2.0 > Login (Google, Naver, Kakao)

## Introduction
This sample project demonstrates OAuth 2.0 login (Google, Naver, Kakao) using Delphi 12.2, TMS XData, and FNC Component Studio.
It includes a REST API server (for handling RedirectURI callbacks) and a Delphi FMX application running on Windows and Android.

## Folder Description
### 1. API-SERVER
- Contains a sample REST API project built with **TMS XData**.
- **OAuth 2.0 RedirectURI** handling logic has been added and updated to the existing code.

### 2. OAuth-Google-Naver-Kakao
- A demonstration application that performs OAuth 2.0 login with **Google, Naver, and Kakao**.
- Verified to work properly on both Windows and Android environments.

--------------------------------
[ENG]
https://www.canva.com/design/DAG7GRpMsZQ/1XuYIBp0CZQQc_dHMaWqtQ/edit?utm_content=DAG7GRpMsZQ&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

[Event Information Link(Korean)]
https://docs.google.com/forms/d/e/1FAIpQLSfu-4tv_c1gnBX3yoVKaawsWHF7-kElHFOYMHIrGZBN_-c2Zg/viewform

[KOR]
https://www.canva.com/design/DAG55iNNWV4/-JmGrMfm8q5cnTBsL2fzvg/edit?utm_content=DAG55iNNWV4&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

--------------------------------
# Delphi 30th Anniversary Year-End Developer Workshop – Registration Form

You are invited to the Delphi 30th Anniversary Year-End Developer Workshop. This event will feature open discussions and topic presentations where developers can share their experiences, challenges, and insights on various technical subjects. Let’s wrap up 2025 together and start 2026 even better.

(Seats are limited. After submitting your request for an invitation here, a final confirmation will be sent separately.)

Event Name: Delphi 30th Anniversary Year-End Developer Workshop
Date & Time: December 11 (Thu), 2:00 PM – 6:00 PM
(Official presentations begin at 2:30 PM)
Venue: Gangnam Beach (200m from Exit 11 of Gangnam Station, https://naver.me/xLSF7Nwc
)
Audience: Delphi developers
Capacity: Approximately 40 participants
Format: Topic presentations & open discussions
Registration: https://forms.gle/YPV91s1zpT42B1DU9

## Schedule

2:00 – 2:30 PM: Check-in & informal networking
2:30 – 3:00 PM: Topic Presentation (Technology Stack*) + Q&A, Open Discussion, Free Networking
3:00 – 3:30 PM: Topic Presentation (Developer Productivity*) + Q&A, Open Discussion, Free Networking
3:30 – 4:00 PM: Topic Presentation (Platform Applications*) + Q&A, Open Discussion, Free Networking
4:00 – 5:00 PM: Participant Lightning Talks
(Your current projects, challenges, and solution efforts)
5:00 – 6:00 PM: Dinner & Free Discussion

## Details of Public Topic Presentations

1) Migrating from 32-bit to 64-bit + Build & Release Process (SQLGate, Yang Yong-seong)
- Explanation of why and how SQLGate V10 transitioned from 32-bit to 64-bit, including an overview of the automated build and deployment pipeline.

2) Delphi Application Development Demo Using Claude AI (Delmadang Admin, Ahn Young-je)
- Demonstration of how any Delphi developer can easily build a classic Minesweeper Windows application using Claude AI.

3) Implementing Google, Naver, and Kakao Login Using OAuth 2.0 on Windows and Mobile (PointHub, Tae Hyun Kim)
- An introduction to implementing OAuth 2.0 login for Windows and Android apps based on the latest development environment.

## Format & Additional Information

1) Aside from the presentation times, participants are free to move around and engage in discussions with other developers.

2) Dinner will be provided from 5 PM (or earlier around 4 PM).

3) Coffee, beverages, and light snacks will be available from 2 PM until dinner.

---------------------------------------------
# Delphi + OAuth 2.0 > Login (Google, Naver, Kakao)

## 소개
Delphi 12.2와 TMS XData 및 FNC Component Studio를 활용한 OAuth 2.0 로그인을위한 REST API 서버(for RedirectURI)와 Delphi FMX 응용프로그램으로 Windows, Android 환경에서 Google, Naver, Kakao OAuth 2.0 로그인 샘플프로젝트를 진행합니다.

## 폴더설명
### 1. API-SERVER
- **TMS XData**로 제작된 샘플 REST API 프로젝트가 존재합니다.
- **OAuth 2.0 RedirectURI** 업무처리가 기존 코드에 업데이트 되었습니다.

### 2. OAuth-Google-Naver-Kakao
- Google, Naver, Kakao 로 OAuth 2.0 로그인 시현용 응용프로그램 구현
- Windows와 Android환경에서 정상구동 확인

# TMS WEB Core와 BIZ를 활용해 VCL넘어 WEB으로 가자!

## 소개
Delphi 12와 TMS WEB Core와 BIZ, Redis로 TMS XData를 활용한 REST API구현하고 TMS WEB Core를 활용한 API연동샘플을 구현했습니다.
API KEY처리 및 DATA 조회, 화면표시 처리를 2024.11.07 서울 세미나와 2024.11.08 부산 세미나때 활용될 샘플 델파이 프로젝트입니다.   

## 폴더설명
### 1. COMMON
- **ApiServer**와 **WetTest** 웹페이지간 API연동 처리시 사용될 record(구조체)가 정의된 uApiProtocols.pas가 위치합니다. **ApiServer**와 **WetTest** 웹페이지서 공용으로 참조됩니다. 

### 2. API-SERVER
- **TMS XData**로 제작된 샘플 REST API 프로젝트가 존재합니다.

### 3. WEB-TEST 
- **TMS WEB Core**로 제작된 샘플 웹페이지 프로젝트가 존해합니다.

- -------------------------------

# Move Beyond VCL to the Web with TMS WEB Core and BIZ!

## Introduction
Using Delphi 12, TMS WEB Core, BIZ, and Redis, we implemented REST APIs with TMS XData and developed API integration samples utilizing TMS WEB Core. 
This Delphi project serves as a sample for processing API keys, data retrieval, and screen display handling for the seminars scheduled in Seoul on 2024.11.07 and in Busan on 2024.11.08.   

## Folder Descriptions
### 1. COMMON
- Contains uApiProtocols.pas, which defines records (structures) used for API integration between **ApiServer** and the **WetTest web page**. This file is commonly referenced by both **ApiServer** and the **WetTest web page**.

### 2. API-SERVER
- Contains a sample REST API project developed with **TMS XData**.

### 3. WEB-TEST 
- Contains a sample web page project developed with **TMS WEB Core**.

- -------------------------------
[ENG]
https://www.canva.com/design/DAGUBuI9Phg/BqPCwcz4abR4FqBk6LAwoA/edit?utm_content=DAGUBuI9Phg&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

[한글]
https://www.canva.com/design/DAGT_bU2s5E/UeRLFRTzk9M_7QNpnd7yuQ/edit?utm_content=DAGT_bU2s5E&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

