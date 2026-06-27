# urirun-contract-windowpair

SUMD - Structured Unified Markdown Descriptor for AI-aware project refactorization

## Contents

- [Metadata](#metadata)
- [Architecture](#architecture)
- [Workflows](#workflows)
- [Call Graph](#call-graph)
- [Refactoring Analysis](#refactoring-analysis)
- [Intent](#intent)

## Metadata

- **name**: `urirun-contract-windowpair`
- **version**: `0.0.0`
- **ecosystem**: SUMD + DOQL + testql + taskfile
- **generated_from**: Makefile, app.doql.less, .env.example, docker-compose.yml, project/(5 analysis files)

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

## Refactoring Analysis

*Pre-refactoring snapshot — use this section to identify targets. Generated from `project/` toon files.*

### Call Graph & Complexity (`project/calls.toon.yaml`)

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

### Code Analysis (`project/analysis.toon.yaml`)

```toon markpact:analysis path=project/analysis.toon.yaml
# code2llm | 24f 1452L | python:9,yaml:4,shell:3,json:1,yml:1,go:1 | 2026-06-27
# generated in 0.00s
# CC̅=4.3 | critical:1/28 | dups:1 | cycles:0

HEALTH[2]:
  🔴 DUP   1 classes duplicated
  🟡 CC    checkSchema CC=30 (limit:15)

REFACTOR[2]:
  1. rm duplicates  (-1 dup classes)
  2. split 1 high-CC methods  (CC>15)

PIPELINES[13]:
  [1] Src [_err]: _err
      PURITY: 100% pure
  [2] Src [do_GET]: do_GET
      PURITY: 100% pure
  [3] Src [do_POST]: do_POST → restore_handler
      PURITY: 100% pure
  [4] Src [do_GET]: do_GET
      PURITY: 100% pure
  [5] Src [do_POST]: do_POST → close_handler
      PURITY: 100% pure
  [6] Src [handleRun]: handleRun → checkSchema → typeOK
      PURITY: 100% pure
  [7] Src [main]: main → loadContracts
      PURITY: 100% pure
  [8] Src [close]: close
      PURITY: 100% pure
  [9] Src [restore]: restore
      PURITY: 100% pure
  [10] Src [load]: load
      PURITY: 100% pure
  [11] Src [main]: main → validate_doc
      PURITY: 100% pure
  [12] Src [main]: main → wait_ready
      PURITY: 100% pure
  [13] Src [emit]: emit
      PURITY: 100% pure

LAYERS:
  packages/                       CC̄=5.1    ←in:0  →out:0  ×DUP
  │ !! service.go                 249L  0C    7m  CC=30     ←0
  │ service                     79L  1C    5m  CC=8      ←0  ×DUP
  │ service                     66L  1C    4m  CC=4      ←0  ×DUP
  │ Dockerfile                  15L  0C    0m  CC=0.0    ←0
  │ Dockerfile                  11L  0C    0m  CC=0.0    ←0
  │ Dockerfile                  11L  0C    0m  CC=0.0    ←0
  │
  toolkit/                        CC̄=5.0    ←in:0  →out:0
  │ contracts_io                14L  0C    1m  CC=5      ←0
  │ contract_gate               12L  0C    0m  CC=0.0    ←0
  │
  ci/                             CC̄=4.6    ←in:0  →out:0
  │ nl_to_contract             103L  0C    4m  CC=10     ←0
  │ emit_handlers               35L  0C    1m  CC=1      ←0
  │ regen_check                 27L  0C    0m  CC=0.0    ←0
  │ pre_commit.sh               10L  0C    0m  CC=0.0    ←0
  │
  orchestrator/                   CC̄=2.2    ←in:0  →out:0
  │ drive                       86L  0C    4m  CC=3      ←0
  │ Dockerfile                   8L  0C    0m  CC=0.0    ←0
  │
  src/                            CC̄=1.0    ←in:0  →out:0
  │ handlers_generated          19L  0C    2m  CC=1      ←0
  │
  ./                              CC̄=0.0    ←in:0  →out:0
  │ planfile.yaml              331L  0C    0m  CC=0.0    ←0
  │ contracts.json             119L  0C    0m  CC=0.0    ←0
  │ prefact.yaml                94L  0C    0m  CC=0.0    ←0
  │ project.sh                  69L  0C    0m  CC=0.0    ←0
  │ docker-compose.yml          42L  0C    0m  CC=0.0    ←0
  │ Makefile                    30L  0C    0m  CC=0.0    ←0
  │ .pre-commit-config.yaml     10L  0C    0m  CC=0.0    ←0
  │ litellm.config.yaml          8L  0C    0m  CC=0.0    ←0
  │ tree.sh                      4L  0C    0m  CC=0.0    ←0
  │

COUPLING: no cross-package imports detected

EXTERNAL:
  validation: run `vallm batch .` → validation.toon
  duplication: run `redup scan .` → duplication.toon
```

### Duplication (`project/duplication.toon.yaml`)

```toon markpact:analysis path=project/duplication.toon.yaml
# redup/duplication | 0 groups | 0f 0L | 2026-06-27

SUMMARY:
  files_scanned: 0
  total_lines:   0
  dup_groups:    0
  dup_fragments: 0
  saved_lines:   0
  scan_ms:       4
```

### Evolution / Churn (`project/evolution.toon.yaml`)

```toon markpact:analysis path=project/evolution.toon.yaml
# code2llm/evolution | 28 func | 8f | 2026-06-27
# generated in 0.00s

NEXT[1] (ranked by impact):
  [1] !! SPLIT-FUNC      checkSchema  CC=30  fan=8
      WHY: CC=30 exceeds 15
      EFFORT: ~1h  IMPACT: 240


RISKS[0]: none

METRICS-TARGET:
  CC̄:          4.3 → ≤3.0
  max-CC:      30 → ≤15
  god-modules: 0 → 0
  high-CC(≥15): 1 → ≤0
  hub-types:   0 → ≤0

PATTERNS (language parser shared logic):
  _extract_declarations() in base.py — unified extraction for:
    - TypeScript: interfaces, types, classes, functions, arrow funcs
    - PHP: namespaces, traits, classes, functions, includes
    - Ruby: modules, classes, methods, requires
    - C++: classes, structs, functions, #includes
    - C#: classes, interfaces, methods, usings
    - Java: classes, interfaces, methods, imports
    - Go: packages, functions, structs
    - Rust: modules, functions, traits, use statements

  Shared regex patterns per language:
    - import: language-specific import/require/using patterns
    - class: class/struct/trait declarations with inheritance
    - function: function/method signatures with visibility
    - brace_tracking: for C-family languages ({ })
    - end_keyword_tracking: for Ruby (module/class/def...end)

  Benefits:
    - Consistent extraction logic across all languages
    - Reduced code duplication (~70% reduction in parser LOC)
    - Easier maintenance: fix once, apply everywhere
    - Standardized FunctionInfo/ClassInfo models

HISTORY:
  prev CC̄=5.2 → now CC̄=4.3
```

## Intent

urirun-contract-windowpair
