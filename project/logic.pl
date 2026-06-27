% ── Project Metadata ─────────────────────────────────────
project_metadata('urirun-contract-windowpair', '0.0.0', 'python').

% ── Project Files ────────────────────────────────────────
project_file('app.doql.less', 61, 'less').
project_file('ci/emit_handlers.py', 36, 'python').
project_file('ci/nl_to_contract.py', 104, 'python').
project_file('ci/pre_commit.sh', 11, 'shell').
project_file('ci/regen_check.py', 28, 'python').
project_file('orchestrator/drive.py', 87, 'python').
project_file('packages/consumer/service.py', 80, 'python').
project_file('packages/consumer-go/service.go', 250, 'go').
project_file('packages/producer/service.py', 67, 'python').
project_file('project.sh', 69, 'shell').
project_file('src/handlers_generated.py', 20, 'python').
project_file('toolkit/contract_gate.py', 13, 'python').
project_file('toolkit/contracts_io.py', 15, 'python').
project_file('tree.sh', 5, 'shell').

% ── Python Functions ─────────────────────────────────────
python_function('ci/emit_handlers.py', 'emit', 1, 1, 2).
python_function('ci/nl_to_contract.py', 'ask_llm', 1, 1, 6).
python_function('ci/nl_to_contract.py', 'validate_doc', 1, 10, 6).
python_function('ci/nl_to_contract.py', '_mock', 1, 2, 3).
python_function('ci/nl_to_contract.py', 'main', 0, 9, 10).
python_function('orchestrator/drive.py', 'post', 2, 1, 6).
python_function('orchestrator/drive.py', 'wait_ready', 2, 3, 4).
python_function('orchestrator/drive.py', '_run_pair', 3, 2, 6).
python_function('orchestrator/drive.py', 'main', 0, 3, 3).
python_function('packages/consumer/service.py', 'restore_handler', 1, 1, 1).
python_function('packages/producer/service.py', 'close_handler', 1, 1, 0).
python_function('src/handlers_generated.py', 'close', 1, 1, 3).
python_function('src/handlers_generated.py', 'restore', 1, 1, 3).
python_function('toolkit/contracts_io.py', 'load', 1, 5, 5).

% ── Python Classes ───────────────────────────────────────
python_class('packages/consumer/service.py', 'Handler').
python_method('Handler', 'log_message', 0, 1, 0).
python_method('Handler', '_err', 3, 2, 7).
python_method('Handler', 'do_GET', 0, 1, 4).
python_method('Handler', 'do_POST', 0, 8, 14).
python_class('packages/producer/service.py', 'Handler').
python_method('Handler', 'log_message', 0, 1, 0).
python_method('Handler', 'do_GET', 0, 1, 4).
python_method('Handler', 'do_POST', 0, 4, 12).

% ── Dependencies ─────────────────────────────────────────

% ── Makefile Targets ─────────────────────────────────────
makefile_target('help', '').
makefile_target('install', '').
makefile_target('install-dev', '').
makefile_target('contract', '').
makefile_target('gen', '').
makefile_target('check', '').
makefile_target('integration', '').

% ── Taskfile Tasks ───────────────────────────────────────

% ── Environment Variables ────────────────────────────────
env_variable('ANTHROPIC_API_KEY', '*(not set)*', '=============================================================================').
env_variable('LLM_MODEL', 'claude-sonnet-4-6', '').
env_variable('PFIX_AUTO_APPLY', 'true', 'true = apply fixes without asking').
env_variable('PFIX_AUTO_INSTALL_DEPS', 'true', 'true = auto pip/uv install').
env_variable('PFIX_AUTO_RESTART', 'false', 'true = os.execv restart after fix').
env_variable('PFIX_MAX_RETRIES', '3', '').
env_variable('PFIX_DRY_RUN', 'false', '').
env_variable('PFIX_ENABLED', 'true', '').
env_variable('PFIX_GIT_COMMIT', 'false', 'true = auto-commit fixes').
env_variable('PFIX_GIT_PREFIX', 'pfix:', 'commit message prefix').
env_variable('PFIX_CREATE_BACKUPS', 'false', 'false = disable .pfix_backups/ directory').

% ── TestQL Scenarios ─────────────────────────────────────

% ── Semantic Facts from SUMD.md ──────────────────────────
sumd_declared_file('app.doql.less', 'doql').
sumd_declared_file('project/map.toon.yaml', 'analysis').
sumd_declared_file('project/logic.pl', 'analysis').
sumd_declared_file('project/calls.toon.yaml', 'analysis').
sumd_workflow('install', 'manual').
sumd_workflow_step('install', 1, 'pip install urirun-contract').
sumd_workflow('install-dev', 'manual').
sumd_workflow_step('install-dev', 1, 'pip install urirun-contract litellm pre-commit').
sumd_workflow('contract', 'manual').
sumd_workflow_step('contract', 1, '$(PY) ci/nl_to_contract.py').
sumd_workflow('gen', 'manual').
sumd_workflow_step('gen', 1, '$(PY) ci/emit_handlers.py').
sumd_workflow('check', 'manual').
sumd_workflow_step('check', 1, 'bash ci/pre_commit.sh').
sumd_workflow('integration', 'manual').
sumd_workflow_step('integration', 1, 'CONTRACTS=contracts.json PORT=8801 $(PY) packages/producer/service.py & P1=$$!').
sumd_workflow_step('integration', 2, 'CONTRACTS=contracts.json PORT=8802 $(PY) packages/consumer/service.py & P2=$$!').
sumd_workflow_step('integration', 3, 'go build -C packages/consumer-go -o /tmp/_wp_consumer_go . && \').
sumd_workflow_step('integration', 4, 'CONTRACTS=$$PWD/contracts.json PORT=8803 /tmp/_wp_consumer_go & P3=$$!').
sumd_workflow_step('integration', 5, 'sleep 2').
sumd_workflow_step('integration', 6, 'CONTRACTS=contracts.json CONSUMER_GO_URL=http://localhost:8803 $(PY) orchestrator/drive.py').
sumd_workflow_step('integration', 7, 'CODE=$$?').
sumd_deploy_target('docker_compose').
sumd_deploy_compose_file('docker-compose.yml').

