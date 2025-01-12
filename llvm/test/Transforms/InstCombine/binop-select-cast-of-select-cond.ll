; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i64 @add_select_zext(i1 %c) {
; CHECK-LABEL: define i64 @add_select_zext
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[ADD:%.*]] = select i1 [[C]], i64 65, i64 1
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %sel = select i1 %c, i64 64, i64 1
  %ext = zext i1 %c to i64
  %add = add i64 %sel, %ext
  ret i64 %add
}

define i64 @add_select_sext(i1 %c) {
; CHECK-LABEL: define i64 @add_select_sext
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[ADD:%.*]] = select i1 [[C]], i64 63, i64 1
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %sel = select i1 %c, i64 64, i64 1
  %ext = sext i1 %c to i64
  %add = add i64 %sel, %ext
  ret i64 %add
}

define i64 @add_select_not_zext(i1 %c) {
; CHECK-LABEL: define i64 @add_select_not_zext
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[ADD:%.*]] = select i1 [[C]], i64 64, i64 2
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %sel = select i1 %c, i64 64, i64 1
  %not.c = xor i1 %c, true
  %ext = zext i1 %not.c to i64
  %add = add i64 %sel, %ext
  ret i64 %add
}

define i64 @add_select_not_sext(i1 %c) {
; CHECK-LABEL: define i64 @add_select_not_sext
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[ADD:%.*]] = select i1 [[C]], i64 64, i64 0
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %sel = select i1 %c, i64 64, i64 1
  %not.c = xor i1 %c, true
  %ext = sext i1 %not.c to i64
  %add = add i64 %sel, %ext
  ret i64 %add
}

define i64 @sub_select_sext(i1 %c, i64 %arg) {
; CHECK-LABEL: define i64 @sub_select_sext
; CHECK-SAME: (i1 [[C:%.*]], i64 [[ARG:%.*]]) {
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[C]], i64 65, i64 [[ARG]]
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %sel = select i1 %c, i64 64, i64 %arg
  %ext = sext i1 %c to i64
  %sub = sub i64 %sel, %ext
  ret i64 %sub
}

define i64 @sub_select_not_zext(i1 %c, i64 %arg) {
; CHECK-LABEL: define i64 @sub_select_not_zext
; CHECK-SAME: (i1 [[C:%.*]], i64 [[ARG:%.*]]) {
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[C]], i64 [[ARG]], i64 63
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %sel = select i1 %c, i64 %arg, i64 64
  %not.c = xor i1 %c, true
  %ext = zext i1 %not.c to i64
  %sub = sub i64 %sel, %ext
  ret i64 %sub
}

define i64 @sub_select_not_sext(i1 %c, i64 %arg) {
; CHECK-LABEL: define i64 @sub_select_not_sext
; CHECK-SAME: (i1 [[C:%.*]], i64 [[ARG:%.*]]) {
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[C]], i64 [[ARG]], i64 65
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %sel = select i1 %c, i64 %arg, i64 64
  %not.c = xor i1 %c, true
  %ext = sext i1 %not.c to i64
  %sub = sub i64 %sel, %ext
  ret i64 %sub
}

define i64 @mul_select_zext(i1 %c, i64 %arg) {
; CHECK-LABEL: define i64 @mul_select_zext
; CHECK-SAME: (i1 [[C:%.*]], i64 [[ARG:%.*]]) {
; CHECK-NEXT:    [[MUL:%.*]] = select i1 [[C]], i64 [[ARG]], i64 0
; CHECK-NEXT:    ret i64 [[MUL]]
;
  %sel = select i1 %c, i64 %arg, i64 1
  %ext = zext i1 %c to i64
  %mul = mul i64 %sel, %ext
  ret i64 %mul
}

define i64 @mul_select_sext(i1 %c) {
; CHECK-LABEL: define i64 @mul_select_sext
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[MUL:%.*]] = select i1 [[C]], i64 -64, i64 0
; CHECK-NEXT:    ret i64 [[MUL]]
;
  %sel = select i1 %c, i64 64, i64 1
  %ext = sext i1 %c to i64
  %mul = mul i64 %sel, %ext
  ret i64 %mul
}

define i64 @select_zext_different_condition(i1 %c, i1 %d) {
; CHECK-LABEL: define i64 @select_zext_different_condition
; CHECK-SAME: (i1 [[C:%.*]], i1 [[D:%.*]]) {
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[C]], i64 64, i64 1
; CHECK-NEXT:    [[EXT:%.*]] = zext i1 [[D]] to i64
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i64 [[SEL]], [[EXT]]
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %sel = select i1 %c, i64 64, i64 1
  %ext = zext i1 %d to i64
  %add = add i64 %sel, %ext
  ret i64 %add
}

define <2 x i64> @vector_test(i1 %c) {
; CHECK-LABEL: define <2 x i64> @vector_test
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[C]], <2 x i64> <i64 64, i64 64>, <2 x i64> <i64 1, i64 1>
; CHECK-NEXT:    [[EXT:%.*]] = zext i1 [[C]] to i64
; CHECK-NEXT:    [[VEC0:%.*]] = insertelement <2 x i64> undef, i64 [[EXT]], i64 0
; CHECK-NEXT:    [[VEC1:%.*]] = shufflevector <2 x i64> [[VEC0]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw <2 x i64> [[SEL]], [[VEC1]]
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %sel = select i1 %c, <2 x i64> <i64 64, i64 64>, <2 x i64> <i64 1, i64 1>
  %ext = zext i1 %c to i64
  %vec0 = insertelement <2 x i64> undef, i64 %ext, i32 0
  %vec1 = insertelement <2 x i64> %vec0, i64 %ext, i32 1
  %add = add <2 x i64> %sel, %vec1
  ret <2 x i64> %add
}

define i64 @multiuse_add(i1 %c) {
; CHECK-LABEL: define i64 @multiuse_add
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[ADD2:%.*]] = select i1 [[C]], i64 66, i64 2
; CHECK-NEXT:    ret i64 [[ADD2]]
;
  %sel = select i1 %c, i64 64, i64 1
  %ext = zext i1 %c to i64
  %add = add i64 %sel, %ext
  %add2 = add i64 %add, 1
  ret i64 %add2
}

define i64 @multiuse_select(i1 %c) {
; CHECK-LABEL: define i64 @multiuse_select
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[MUL:%.*]] = select i1 [[C]], i64 4032, i64 0
; CHECK-NEXT:    ret i64 [[MUL]]
;
  %sel = select i1 %c, i64 64, i64 0
  %ext = zext i1 %c to i64
  %add = sub i64 %sel, %ext
  %mul = mul i64 %sel, %add
  ret i64 %mul
}

define i64 @select_non_const_sides(i1 %c, i64 %arg1, i64 %arg2) {
; CHECK-LABEL: define i64 @select_non_const_sides
; CHECK-SAME: (i1 [[C:%.*]], i64 [[ARG1:%.*]], i64 [[ARG2:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[ARG1]], -1
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[C]], i64 [[TMP1]], i64 [[ARG2]]
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = zext i1 %c to i64
  %sel = select i1 %c, i64 %arg1, i64 %arg2
  %sub = sub i64 %sel, %ext
  ret i64 %sub
}

define i6 @sub_select_sext_op_swapped_non_const_args(i1 %c, i6 %argT, i6 %argF) {
; CHECK-LABEL: define i6 @sub_select_sext_op_swapped_non_const_args
; CHECK-SAME: (i1 [[C:%.*]], i6 [[ARGT:%.*]], i6 [[ARGF:%.*]]) {
; CHECK-DAG:     [[TMP1:%.*]] = xor i6 [[ARGT]], -1
; CHECK-DAG:     [[TMP2:%.*]] = sub i6 0, [[ARGF]]
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[C]], i6 [[TMP1]], i6 [[TMP2]]
; CHECK-NEXT:    ret i6 [[SUB]]
;
  %sel = select i1 %c, i6 %argT, i6 %argF
  %ext = sext i1 %c to i6
  %sub = sub i6 %ext, %sel
  ret i6 %sub
}

define i6 @sub_select_zext_op_swapped_non_const_args(i1 %c, i6 %argT, i6 %argF) {
; CHECK-LABEL: define i6 @sub_select_zext_op_swapped_non_const_args
; CHECK-SAME: (i1 [[C:%.*]], i6 [[ARGT:%.*]], i6 [[ARGF:%.*]]) {
; CHECK-DAG:     [[TMP1:%.*]] = sub i6 1, [[ARGT]]
; CHECK-DAG:     [[TMP2:%.*]] = sub i6 0, [[ARGF]]
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[C]], i6 [[TMP1]], i6 [[TMP2]]
; CHECK-NEXT:    ret i6 [[SUB]]
;
  %sel = select i1 %c, i6 %argT, i6 %argF
  %ext = zext i1 %c to i6
  %sub = sub i6 %ext, %sel
  ret i6 %sub
}
