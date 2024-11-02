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
- Contains uApiProtocols.pas, which defines records (structures) used for API integration between **ApiServer** and the **web page**. This file is commonly referenced by both **ApiServer** and the **web page**.

### 2. API-SERVER
- Contains a sample REST API project developed with **TMS XData**.

### 3. WEB-TEST 
- Contains a sample web page project developed with **TMS WEB Core**.
