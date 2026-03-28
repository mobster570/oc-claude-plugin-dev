# SKILL-CREATOR KNOWLEDGE BASE

## OVERVIEW

Eval-driven skill development framework: create skills, test triggering with parallel evals, iterate with benchmarks, optimize descriptions. Most complex subsystem — has Python scripts, nested agents, HTML viewer.

## STRUCTURE

```
skill-creator/
├── SKILL.md              # Main skill definition (479 lines) — workflow + instructions
├── scripts/              # Python evaluation & utility scripts
│   ├── run_eval.py       # Core: parallel trigger eval runner (ProcessPoolExecutor)
│   ├── run_loop.py       # Iterative eval+improve cycle with train/test split
│   ├── improve_description.py  # Optimizes SKILL.md description for triggering
│   ├── aggregate_benchmark.py  # Variance analysis across eval runs
│   ├── generate_report.py      # Evaluation report generation
│   ├── quick_validate.py       # Fast structural validation of skill files
│   ├── package_skill.py        # Packages skill for distribution
│   ├── utils.py                # Shared: SKILL.md parsing, frontmatter extraction
│   └── __init__.py
├── agents/               # Nested evaluation agents
│   ├── analyzer.md       # Surfaces patterns in eval results (NO improvement suggestions)
│   ├── comparator.md     # Blind A/B comparison of skill versions
│   └── grader.md         # Grades skill quality with rubric
├── references/
│   └── schemas.md        # JSON schemas for eval sets and results
├── eval-viewer/
│   └── generate_review.py  # Generates HTML eval result viewer
├── assets/
│   └── eval_review.html    # HTML template for eval visualization
└── LICENSE.txt             # Apache 2.0
```

## WHERE TO LOOK

| Task | File | Notes |
|------|------|-------|
| Understand the full workflow | `SKILL.md` | Read lines 1-30 for overview |
| Run trigger evaluations | `scripts/run_eval.py` | Needs `claude -p` CLI |
| Iterative improvement loop | `scripts/run_loop.py` | Train/test split, overfitting prevention |
| Optimize skill description | `scripts/improve_description.py` | Runs after eval baseline exists |
| Validate a skill quickly | `scripts/quick_validate.py` | Checks frontmatter, naming, fields |
| Understand eval data format | `references/schemas.md` | `evals.json` schema with `should_trigger` |
| View eval results as HTML | `eval-viewer/generate_review.py` | Generates from eval output |
| Shared parsing utilities | `scripts/utils.py` | SKILL.md parser, frontmatter extractor |
| Analyze eval patterns | `agents/analyzer.md` | DO NOT suggest improvements here |
| Compare skill versions | `agents/comparator.md` | Blind comparison — don't infer sources |

## WORKFLOW

```
1. Draft SKILL.md          → Write skill body + YAML frontmatter
2. Create evals.json       → Queries with should_trigger boolean
3. run_eval.py             → Parallel trigger testing (baseline)
4. analyzer.md agent       → Surface patterns (no improvements!)
5. Iterate                 → Modify skill → re-eval → compare
6. improve_description.py  → Optimize triggering description
7. run_loop.py             → Automated eval+improve until convergence
8. package_skill.py        → Bundle for distribution
```

## CONVENTIONS

- **Eval sets**: `evals.json` — array of `{ query, should_trigger }` objects
- **Results layout**: `<skill-name>-workspace/iteration-N/eval-M/`
- **Train/test split**: Stratified sampling to prevent overfitting
- **Blind comparison**: `comparator.md` must never know which version produced which output
- **Analyzer scope**: Pattern analysis ONLY — improvements belong to the improvement step
- **All Python scripts** require Python 3.x, no external deps beyond stdlib
- **`claude -p`** CLI calls required for `run_eval.py` and `run_loop.py`
