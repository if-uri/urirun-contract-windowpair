# urirun-contract-windowpair

urirun-contract-windowpair

## Contents

- [Metadata](#metadata)
- [Architecture](#architecture)
- [Workflows](#workflows)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Environment Variables (`.env.example`)](#environment-variables-envexample)
- [Makefile Targets](#makefile-targets)
- [Code Analysis](#code-analysis)
- [Call Graph](#call-graph)
- [Intent](#intent)

## Metadata

- **name**: `urirun-contract-windowpair`
- **version**: `0.0.0`
- **ecosystem**: SUMD + DOQL + testql + taskfile
- **generated_from**: Makefile, app.doql.less, .env.example, docker-compose.yml, project/(3 analysis files)

## Architecture

```
SUMD (description) → DOQL/source (code) → taskfile (automation) → testql (verification)
```

### DOQL Application Declaration (`app.doql.less`)

```less markpact:doql path=app.doql.less
// LESS format — define @variables here as needed

app {
  name: urirun-contract-windowpair;
  version: 0.1.0;
}

workflow[name="install"] {
  trigger: manual;
  step-1: run cmd=pip install urirun-contract;
}

workflow[name="install-dev"] {
  trigger: manual;
  step-1: run cmd=pip install urirun-contract litellm pre-commit;
}

workflow[name="contract"] {
  trigger: manual;
  step-1: run cmd=$(PY) ci/nl_to_contract.py;
}

workflow[name="gen"] {
  trigger: manual;
  step-1: run cmd=$(PY) ci/emit_handlers.py;
}

workflow[name="check"] {
  trigger: manual;
  step-1: run cmd=bash ci/pre_commit.sh;
}

workflow[name="integration"] {
  trigger: manual;
  step-1: run cmd=CONTRACTS=contracts.json PORT=8801 $(PY) packages/producer/service.py & P1=$$!; \;
  step-2: run cmd=CONTRACTS=contracts.json PORT=8802 $(PY) packages/consumer/service.py & P2=$$!; \;
  step-3: run cmd=go build -C packages/consumer-go -o /tmp/_wp_consumer_go . && \;
  step-4: run cmd=CONTRACTS=$$PWD/contracts.json PORT=8803 /tmp/_wp_consumer_go & P3=$$!; \;
  step-5: run cmd=sleep 2; \;
  step-6: run cmd=CONTRACTS=contracts.json CONSUMER_GO_URL=http://localhost:8803 $(PY) orchestrator/drive.py; \;
  step-7: run cmd=CODE=$$?; kill $$P1 $$P2 $$P3 2>/dev/null; exit $$CODE;
}

env_vars {
  keys: OPENROUTER_API_KEY, LLM_MODEL, PFIX_AUTO_APPLY, PFIX_AUTO_INSTALL_DEPS, PFIX_AUTO_RESTART, PFIX_MAX_RETRIES, PFIX_DRY_RUN, PFIX_ENABLED, PFIX_GIT_COMMIT, PFIX_GIT_PREFIX, PFIX_CREATE_BACKUPS, ANTHROPIC_API_KEY;
}

deploy {
  target: docker-compose;
  compose_file: docker-compose.yml;
}

environment[name="local"] {
  runtime: docker-compose;
  env_file: .env;
  template_file: .env.example;
  vars: ANTHROPIC_API_KEY, LLM_MODEL, OPENROUTER_API_KEY, PFIX_AUTO_APPLY, PFIX_AUTO_INSTALL_DEPS, PFIX_AUTO_RESTART, PFIX_CREATE_BACKUPS, PFIX_DRY_RUN, PFIX_ENABLED, PFIX_GIT_COMMIT, PFIX_GIT_PREFIX, PFIX_MAX_RETRIES;
  runtime_llm: OPENROUTER_API_KEY;
  runtime_pfix: PFIX_AUTO_APPLY, PFIX_AUTO_INSTALL_DEPS, PFIX_AUTO_RESTART, PFIX_CREATE_BACKUPS, PFIX_DRY_RUN, PFIX_ENABLED, PFIX_GIT_COMMIT, PFIX_GIT_PREFIX, PFIX_MAX_RETRIES;
}
```

## Workflows

## Configuration

```yaml
project:
  name: urirun-contract-windowpair
  version: 0.0.0
  env: local
```

## Deployment

```bash markpact:run
pip install urirun-contract-windowpair

# development install
pip install -e .[dev]
```

### Docker Compose (`docker-compose.yml`)

- **producer** image=`{'context': '.', 'dockerfile': 'packages/producer/Dockerfile'}`
- **consumer** image=`{'context': '.', 'dockerfile': 'packages/consumer/Dockerfile'}`
- **consumer-go** image=`{'context': '.', 'dockerfile': 'packages/consumer-go/Dockerfile'}`
- **orchestrator** image=`{'context': '.', 'dockerfile': 'orchestrator/Dockerfile'}`

## Environment Variables (`.env.example`)

| Variable | Default | Description |
|----------|---------|-------------|
| `ANTHROPIC_API_KEY` | `*(not set)*` | ============================================================================= |
| `LLM_MODEL` | `claude-sonnet-4-6` |  |
| `PFIX_AUTO_APPLY` | `true` | true = apply fixes without asking |
| `PFIX_AUTO_INSTALL_DEPS` | `true` | true = auto pip/uv install |
| `PFIX_AUTO_RESTART` | `false` | true = os.execv restart after fix |
| `PFIX_MAX_RETRIES` | `3` |  |
| `PFIX_DRY_RUN` | `false` |  |
| `PFIX_ENABLED` | `true` |  |
| `PFIX_GIT_COMMIT` | `false` | true = auto-commit fixes |
| `PFIX_GIT_PREFIX` | `pfix:` | commit message prefix |
| `PFIX_CREATE_BACKUPS` | `false` | false = disable .pfix_backups/ directory |

## Makefile Targets

- `help`
- `install`
- `install-dev`
- `contract`
- `gen`
- `check`
- `integration`

## Code Analysis

### `project/map.toon.yaml`

```toon markpact:analysis path=project/map.toon.yaml
# urirun-contract-windowpair | 14f 846L | python:9,shell:3,less:1,go:1 | 2026-06-27
# stats: 14 func | 2 cls | 14 mod | CC̄=2.9 | critical:1 | cycles:0
# alerts[5]: CC validate_doc=10; CC main=9; CC load=5; CC wait_ready=3; CC main=3
# hotspots[5]: main fan=10; ask_llm fan=6; validate_doc fan=6; post fan=6; _run_pair fan=6
# evolution: baseline
# Keys: M=modules, D=details, i=imports, e=exports, c=classes, f=functions, m=methods
M[14]:
  app.doql.less,61
  ci/emit_handlers.py,36
  ci/nl_to_contract.py,104
  ci/pre_commit.sh,11
  ci/regen_check.py,28
  orchestrator/drive.py,87
  packages/consumer/service.py,80
  packages/consumer-go/service.go,250
  packages/producer/service.py,67
  project.sh,69
  src/handlers_generated.py,20
  toolkit/contract_gate.py,13
  toolkit/contracts_io.py,15
  tree.sh,5
D:
  ci/emit_handlers.py:
    e: emit
    emit(contracts_path)
  ci/nl_to_contract.py:
    e: ask_llm,validate_doc,_mock,main
    ask_llm(readme)
    validate_doc(doc)
    _mock(bad)
    main()
  ci/regen_check.py:
  orchestrator/drive.py:
    e: post,wait_ready,_run_pair,main
    post(url;payload)
    wait_ready(url;tries)
    _run_pair(label;producer_url;consumer_url)
    main()
  packages/consumer/service.py:
    e: restore_handler,Handler
    Handler: log_message(0),_err(3),do_GET(0),do_POST(0)
    restore_handler(snapshot)
  packages/producer/service.py:
    e: close_handler,Handler
    Handler: log_message(0),do_GET(0),do_POST(0)
    close_handler(id)
  src/handlers_generated.py:
    e: close,restore
    close(id)
    restore(snapshot)
  toolkit/contract_gate.py:
  toolkit/contracts_io.py:
    e: load
    load(path)
```

### `project/logic.pl`

```prolog markpact:analysis path=project/logic.pl
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
```

## Call Graph

*19 nodes · 14 edges · 5 modules · CC̄=4.3*

### Hubs (by degree)

| Function | CC | in | out | total |
|----------|----|----|-----|-------|
| `validate_doc` *(in ci.nl_to_contract)* | 10 ⚠ | 1 | 19 | **20** |
| `do_POST` *(in packages.consumer.service.Handler)* | 8 | 0 | 20 | **20** |
| `do_POST` *(in packages.producer.service.Handler)* | 4 | 0 | 19 | **19** |
| `main` *(in ci.nl_to_contract)* | 9 | 0 | 17 | **17** |
| `_run_pair` *(in orchestrator.drive)* | 2 | 2 | 11 | **13** |
| `loadContracts` *(in packages.consumer-go.service)* | 6 | 1 | 9 | **10** |
| `main` *(in packages.consumer-go.service)* | 4 | 0 | 10 | **10** |
| `checkSchema` *(in packages.consumer-go.service)* | 30 ⚠ | 1 | 8 | **9** |

```toon markpact:analysis path=project/calls.toon.yaml
# code2llm call graph | /home/tom/github/if-uri/urirun-contract-windowpair
# generated in 0.01s
# nodes: 19 | edges: 14 | modules: 5
# CC̄=4.3

HUBS[20]:
  ci.nl_to_contract.validate_doc
    CC=10  in:1  out:19  total:20
  packages.consumer.service.Handler.do_POST
    CC=8  in:0  out:20  total:20
  packages.producer.service.Handler.do_POST
    CC=4  in:0  out:19  total:19
  ci.nl_to_contract.main
    CC=9  in:0  out:17  total:17
  orchestrator.drive._run_pair
    CC=2  in:2  out:11  total:13
  packages.consumer-go.service.loadContracts
    CC=6  in:1  out:9  total:10
  packages.consumer-go.service.main
    CC=4  in:0  out:10  total:10
  packages.consumer-go.service.checkSchema
    CC=30  in:1  out:8  total:9
  orchestrator.drive.post
    CC=1  in:2  out:6  total:8
  ci.nl_to_contract.ask_llm
    CC=1  in:1  out:6  total:7
  orchestrator.drive.wait_ready
    CC=3  in:3  out:4  total:7
  packages.consumer-go.service.writeJSON
    CC=1  in:2  out:5  total:7
  orchestrator.drive.main
    CC=3  in:0  out:6  total:6
  packages.consumer-go.service.handleRun
    CC=8  in:0  out:6  total:6
  ci.nl_to_contract._mock
    CC=2  in:1  out:3  total:4
  packages.consumer.service.restore_handler
    CC=1  in:1  out:2  total:3
  packages.consumer-go.service.restoreHandler
    CC=3  in:1  out:2  total:3
  packages.consumer-go.service.typeOK
    CC=10  in:1  out:1  total:2
  packages.producer.service.close_handler
    CC=1  in:1  out:0  total:1

MODULES:
  ci.nl_to_contract  [4 funcs]
    _mock  CC=2  out:3
    ask_llm  CC=1  out:6
    main  CC=9  out:17
    validate_doc  CC=10  out:19
  orchestrator.drive  [4 funcs]
    _run_pair  CC=2  out:11
    main  CC=3  out:6
    post  CC=1  out:6
    wait_ready  CC=3  out:4
  packages.consumer-go.service  [7 funcs]
    checkSchema  CC=30  out:8
    handleRun  CC=8  out:6
    loadContracts  CC=6  out:9
    main  CC=4  out:10
    restoreHandler  CC=3  out:2
    typeOK  CC=10  out:1
    writeJSON  CC=1  out:5
  packages.consumer.service  [2 funcs]
    do_POST  CC=8  out:20
    restore_handler  CC=1  out:2
  packages.producer.service  [2 funcs]
    do_POST  CC=4  out:19
    close_handler  CC=1  out:0

EDGES:
  packages.consumer.service.Handler.do_POST → packages.consumer.service.restore_handler
  packages.producer.service.Handler.do_POST → packages.producer.service.close_handler
  packages.consumer-go.service.checkSchema → packages.consumer-go.service.typeOK
  packages.consumer-go.service.handleRun → packages.consumer-go.service.checkSchema
  packages.consumer-go.service.handleRun → packages.consumer-go.service.writeJSON
  packages.consumer-go.service.handleRun → packages.consumer-go.service.restoreHandler
  packages.consumer-go.service.main → packages.consumer-go.service.loadContracts
  packages.consumer-go.service.main → packages.consumer-go.service.writeJSON
  ci.nl_to_contract.main → ci.nl_to_contract.validate_doc
  ci.nl_to_contract.main → ci.nl_to_contract._mock
  ci.nl_to_contract.main → ci.nl_to_contract.ask_llm
  orchestrator.drive._run_pair → orchestrator.drive.post
  orchestrator.drive.main → orchestrator.drive.wait_ready
  orchestrator.drive.main → orchestrator.drive._run_pair
```

## Intent

urirun-contract-windowpair
