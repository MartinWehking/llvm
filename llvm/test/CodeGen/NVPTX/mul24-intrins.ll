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

; CHECK-LABEL: madi
define i32 @madi(i16 %a, i16 %b, i16 %c, i16 %d) {
; CHECK-NOT: shl
; CHECK-NOT: shr
; CHECK-NOT: bfe
; CHECK: mul
  %z_a= zext i16 %a to i32
  %z_b = zext i16 %b to i32
  %z_c = zext i16 %c to i32
  %z_d = zext i16 %d to i32
  %mul1 = tail call i32 @llvm.nvvm.mul24.i(i32 %z_a, i32 %z_b)
  %mul2 = tail call i32 @llvm.nvvm.mul24.i(i32 %z_c, i32 %z_d)
  %add = add nsw i32 %mul1, %mul2
  ret i32 %add
}

; CHECK-LABEL: madui
define i32 @madui(i16 %a, i16 %b, i16 %c, i16 %d) {
; CHECK-NOT: shl
; CHECK-NOT: shr
; CHECK-NOT: and
; CHECK: mul
  %z_a= zext i16 %a to i32
  %z_b = zext i16 %b to i32
  %z_c = zext i16 %c to i32
  %z_d = zext i16 %d to i32
  %mul1 = tail call i32 @llvm.nvvm.mul24.ui(i32 %z_a, i32 %z_b)
  %mul2 = tail call i32 @llvm.nvvm.mul24.ui(i32 %z_c, i32 %z_d)
  %add = add nsw i32 %mul1, %mul2
  ret i32 %add
}


