# TMS WEB Core와 BIZ를 활용해 VCL넘어 WEB으로 가자!

## 소개
Delphi 12와 TMS WEB Core와 BIZ, Redis로 TMS XData를 활용한 REST API구현하고 TMS WEB Core를 활용한 API연동샘플을 구현했습니다.
API KEY처리 및 DATA 조회, 화면표시 처리를 2024.11.07 서울 세미나와 2024.11.08 부산 세미나때 활용될 샘플 델파이 프로젝트입니다.   

## 폴더설명
### 1. COMMON
- **ApiServer**와 **WetTest** 웹페이지간 API연동 처리시 사용될 record(구조체)가 정의된 uApiProtocols.pas가 위치합니다. **ApiServer**와 **WetTest** 웹페이지서 공용으로 참조됩니다. 

### 2. API-SERVER
- **TMS XData로 제작된 샘플 REST API 프로젝트가 존재합니다.

### 3. WEB-TEST 
- **TMS WEB Core로 제작된 샘플 웹페이지 프로젝트가 존해합니다.
