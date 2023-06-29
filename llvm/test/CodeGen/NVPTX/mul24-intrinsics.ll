; RUN: llc < %s -march=nvptx -mcpu=sm_20 | FileCheck %s
; RUN: %if ptxas %{ llc < %s -march=nvptx -mcpu=sm_20 | %ptxas-verify %}

declare i32 @llvm.nvvm.mul24.i(i32 %a, i32 %b);
declare i32 @llvm.nvvm.mul24.ui(i32 %a, i32 %b);

; CHECK-LABEL: mul24i
define i32 @mul24i(i32 %a, i32 %b) {
; CHECK: bfe
; CHECK: bfe
; CHECK: mul
  %val = tail call i32 @llvm.nvvm.mul24.i(i32 %a, i32 %b)
  ret i32 %val
}

; CHECK-LABEL: mul24ui
define i32 @mul24ui(i32 %a, i32 %b) {
; CHECK: and
; CHECK: and
; CHECK: mul
  %val = tail call i32 @llvm.nvvm.mul24.ui(i32 %a, i32 %b)
  ret i32 %val
}

; CHECK-LABEL: mul24ibfe
define i32 @mul24ibfe(i16 %a, i16 %b) {
; CHECK-NOT: shl
; CHECK-NOT: shr
; CHECK-NOT: bfe
; CHECK: mul
  %val0 = zext i16 %a to i32
  %val1 = zext i16 %b to i32
  %val2 = tail call i32 @llvm.nvvm.mul24.i(i32 %val0, i32 %val1)
  ret i32 %val2
}

; CHECK-LABEL: mul24uibfe
define i32 @mul24uibfe(i16 %a, i16 %b) {
; CHECK-NOT: shl
; CHECK-NOT: shr
; CHECK-NOT: and
; CHECK: mul
  %val0 = zext i16 %a to i32
  %val1 = zext i16 %b to i32
  %val2 = tail call i32 @llvm.nvvm.mul24.ui(i32 %val0, i32 %val1)
  ret i32 %val2
}


