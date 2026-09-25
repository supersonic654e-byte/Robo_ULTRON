# ROBO_ULTRON — Convenience Makefile
#
# Thin targets that wrap existing scripts and CI commands.
# Nothing new is invented; each target maps 1:1 to something the CI or
# the Bible already defines.  Run `make help` to see available targets.

.PHONY: help test firmware web-test lint-links smoke docs-check all

# ---------- defaults ----------
PYTHON   ?= python3
PYTEST   ?= $(PYTHON) -m pytest
FQBN     ?= arduino:avr:mega:cpu=atmega2560
FW_DIR   ?= versions/V0.3_Ultron/firmware/ultron_firmware
TEST_DIR ?= versions/V0.3_Ultron/tests/scripts
WEB_DIR  ?= versions/V0.3_Ultron/software/web

# ---------- help ----------
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| sort | awk 'BEGIN{FS=":.*?## "};{printf "  \033[36m%-14s\033[0m %s\n",$$1,$2}'

# ---------- testing ----------
test: ## Run all offline unit tests (protocol, safety, depth→scan, web)
	@cd $(TEST_DIR) && $(PYTHON) run_tests.sh

web-test: ## Run only the web control-system test suite
	@cd $(WEB_DIR) && $(PYTEST) -q tests

# ---------- firmware ----------
firmware: ## Compile firmware for Mega 2560 (requires arduino-cli)
	arduino-cli compile --fqbn $(FQBN) $(FW_DIR)

# ---------- lint / docs ----------
lint-links: ## Check all relative markdown links resolve + no abandoned-payload tokens
	@echo "== broken-link check =="
	@$(PYTHON) -c \
		"import os,re,glob;b=[];[(b.append((f,m.group(1))) if not os.path.exists(os.path.normpath(os.path.join(os.path.dirname(f),m.group(1)))) else None) for f in glob.glob('**/*.md',recursive=True) for m in re.finditer(r'\[[^\]]*\]\(([^)#]+)\)',open(f,encoding='utf-8').read()) if not m.group(1).startswith(('http://','https://','#'))] and (print('BROKEN LINK %s -> %s'%x) for x in b) and b and exit(1) or print('all relative links OK')"
	@echo "== abandoned-payload check =="
	@grep -rniE 'Ultron_UV|UV_C|UV-C|uv_controller|FAULT_BIT_UV|PKT_UV' docs versions README.md && exit 1 || echo "abandoned-token check OK"

docs-check: lint-links ## Alias for lint-links (docs consistency)

# ---------- smoke test (needs robot powered) ----------
smoke: ## Run pre-session smoke test (requires robot + ROS 2 on PATH)
	@bash scripts/smoke_test.sh

# ---------- all ----------
all: lint-links test firmware ## Run everything that works offline
	@echo "== all offline checks passed =="
