// Copyright (c) KIM TAE HYUN, 2024.
//
// This file is part of devgear-seminar-2024-11 and is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

unit CommonService;

interface

uses
  XData.Service.Common;

type
  [ServiceContract]
  ICommonService = interface(IInvokable)
    ['{C5CE62AB-D52C-487A-B659-27E94E853FAF}']
    [HttpGet] function Sum(A, B: double): double;
    [HttpPost] function EchoString(Value: string): string;

    [HttpPost] function login( sID, sPW: string ): string;
    [HttpPost] function logout([XDefault('')] sID: string ): string;
    [HttpPost] function VerifyTokenAndExtend( sApiKEY: string): string;

    [HttpGet]  function GetGridDATA( [XDefault('')] sGroupID: string ): string;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(ICommonService));

end.
