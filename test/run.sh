#!/bin/sh
# テストコードの置いてあるディレクトリ(このディレクトリのtests.d)
# 引数として、マーカーの文字列をひとつ受け取る
# 用意されているそれぞれのテストを実行し、その戻り値にマーカー文字列を頭に付けて
# 出力する。
# テストに成功すれば(戻り値0)passedを、失敗すれば(非ゼロ)failedを出力する
TEST_DIR=$(dirname "$0")/tests.d
MARKER="$1"
TESTS=0
PASSED=0
# テストコードの実行
for test_file in "$TEST_DIR"/*.sh; do
  if [ -f "$test_file" ]; then
    TESTS=$(expr $TESTS + 1)
    echo "${MARKER}: Running test: $test_file"
    tmp_test_output=$(mktemp)
    sh "$test_file" > "$tmp_test_output" 2>&1
    test_result=$?
    sed "s/^/${MARKER}: /" "$tmp_test_output"
    rm -f "$tmp_test_output"
    if [ $test_result -ne 0 ]; then
      echo "${MARKER}: Test failed: $test_file"
    else
      echo "${MARKER}: Test passed: $test_file"
      PASSED=$(expr $PASSED + 1)
    fi
  fi
done

# 全てのテストが通れば成功
if [ $TESTS -eq $PASSED ]; then
  echo "${MARKER}: All tests passed($TESTS test(s))."
else
  echo "${MARKER}: Some tests failed. Total: $TESTS, Passed: $PASSED"
fi

exit $(expr $TESTS - $PASSED)