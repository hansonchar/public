LUA = lua
TEST_DIR = algo
TEST_FILES = $(shell find $(TEST_DIR) -type f \( -name "*test.lua" -o -name "*tests*.lua" \))

.PHONY: run-tests
run-tests: $(TEST_FILES)
	@echo "Running tests in $(TEST_DIR):"
	@for test in $^; do \
		echo "Running $$test..."; \
		$(LUA) $$test || { echo "Test failed: $$test"; exit 1; }; \
	done
	@echo "All tests passed!"
