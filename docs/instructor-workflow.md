# Instructor workflow

Students use Colab for Python work and Excel for Lab 1. These local instructions are for the instructor in VS Code or Positron.

## Local authoring

Install uv and Quarto using their official installers. From the repository root, run:

```sh
uv sync
```

uv creates `.venv` and uses `uv.lock` for reproducible local installs. Commit the lockfile. Select `.venv/bin/python` in your editor’s notebook kernel picker. The notebook setup cell uses `%pip` for Colab; use `uv sync` to manage local packages and skip that setup cell locally. Python 3.12 is a suitable interpreter for local work.

Keep the dependency ranges in the Colab setup cell and `pyproject.toml` aligned. Colab resolves packages at runtime and does not use the local lockfile. Test in Colab before each release.

## Visual Payoff

Use this pattern across relevant early Colab lecture notebooks, guided exercises, and labs. Students first process data with Polars, then run a prepared Altair visualization cell near the end to see what their work reveals. Keep the chart focused on the notebook's question and learning objective rather than adding unrelated visual decoration.

1. Identify the Polars result the chart will use, such as filtered observations, a transformed column, a grouped summary, or a validated joined table. Explain in plain language how the preparation step makes the chart possible.
2. Supply a complete visualization cell that uses that result directly. Do not reload the original data, substitute a separate precomputed answer, or silently redo the student's preparation inside the chart cell. Describe the expected column names and units so errors can be traced to the relevant earlier step. Supplied chart code must not disclose instructor solutions to assessed preparation tasks.
3. Label the cell as a prepared visualization that students can run without writing or understanding all the Altair syntax yet. Use a readable chart with a clear title, labeled axes, and relevant units. Where useful, provide a simple prepared selection or filter control using Altair's existing capabilities; interaction is optional and should not require new tools or untaught coding.
4. Add a short prompt connecting the visual result to the preceding data work, such as noticing which groups remain after filtering or which information becomes available after a join. Reuse an existing interpretation or reflection prompt where possible rather than adding another deliverable.
5. Follow the same chart structure in the matched lab, adapted to its different dataset and column names. During early data preparation topics, provide the visualization code. As visualization skills are taught, progressively invite small changes to titles, labels, or encodings, then student-authored charts. Require only chart skills already demonstrated and practiced.

The payoff chart does not add a grading requirement. Running an unchanged prepared chart cell is not evidence for guided participation; preserve the separately marked attempt/reflection cells and original-starter comparison in the [participation workflow](#guided-notebook-participation). An error in the preparation or chart does not reduce participation credit. In graded labs, retain the existing competency-based rubric without adding points or penalties merely for this pattern or for supplied chart code.

For authoring QA, run the notebook from a fresh runtime and confirm the chart uses the actual preceding Polars result. Check that a relevant upstream change is reflected in the chart and that any prepared controls work in Colab. Keep repository notebook outputs cleared after verification. These are instructor checks, not execution requirements for participation grading. Use the normal Colab Altair display workflow; the embedded HTML export pattern remains specific to slides. Lab 1 remains an Excel lab, and this pattern does not make joins mandatory for the final project.

## Test the notebook locally

From the repository root, run this script in your terminal. It validates the notebook, executes its Python analysis cells in a temporary copy, and checks the selected stock-price data, common starting index, and chart specification. It skips the Colab installation command and renderer selection. It never saves execution outputs into the source notebook.

```sh
uv run python - <<'PY'
from pathlib import Path
import nbformat
from nbclient import NotebookClient

path = Path("notebooks/01-first-data-analysis.ipynb")
nb = nbformat.read(path, as_version=4)
nbformat.validate(nb)
for cell in nb.cells:
    if cell.cell_type == "code":
        cell.source = "\n".join(
            line for line in cell.source.splitlines()
            if not line.startswith("%pip ")
            and line != 'alt.renderers.enable("colab")'
        )
nb.cells.append(nbformat.v4.new_code_cell('''
assert selected_prices.shape == (1000, 3)
assert summary.height == 4
assert summary["observations"].to_list() == [250] * 4
starts = indexed_prices.group_by("stock_symbol").agg(pl.col("price_index").first())
assert starts["price_index"].to_list() == [100.0] * 4
spec = chart.to_dict()
assert spec["layer"][0]["mark"]["type"] == "line"
assert spec["layer"][0]["encoding"]["y"]["field"] == "price_index"
'''))
NotebookClient(nb, timeout=120, kernel_name="python3").execute()
print("Notebook validated and analysis checks passed.")
PY
```

This checks Python execution and the chart specification. It does not verify the Colab interface or visually inspect the chart.

These execution checks apply to instructor-authored teaching materials only. Never use them to score submitted guided notebooks.

## Guided notebook participation

This is the intended workflow for future notebooks and a future Python validator. No validator is implemented yet. Guided follow-along notebooks assess participation through a reasonable attempt, not programming competency. Use only Complete (100%) or Incomplete (0%). Code correctness, successful execution, outputs, and analytical results do not affect the score. Keep this process separate from the four graded labs and their competency-based rubrics.

### Authoring and stable identification

Near the end of each future guided notebook, add a clearly labeled participation section with a small code task and an optional Markdown reflection asking what the student tried or learned. State that a meaningful code attempt OR a completed reflection earns full credit, even when the code produces errors. Neither successful execution nor completion of both cells is required.

Use this metadata contract, with values unique to the activity:

| Location | Metadata key | Meaning |
| :--- | :--- | :--- |
| Notebook | `econ3030.activity_id` | Stable activity identifier, such as `guided-01` |
| Notebook | `econ3030.starter_version` | Released starter version, such as `1` |
| Code cell | `econ3030.participation_id` | Stable exercise identifier, such as `guided-01-attempt` |
| Code cell | `econ3030.role` | `attempt` |
| Markdown cell | `econ3030.participation_id` | Stable reflection identifier, such as `guided-01-reflection` |
| Markdown cell | `econ3030.role` | `reflection` |

Here `econ3030` is an object within the notebook or cell's `metadata` object. Keep these identifiers stable if cells move. Identify cells through metadata, never their positions or execution counts. Require the declared cell types and unique participation IDs. The reflection cell is provided in the starter, but writing a reflection is optional.

Archive the exact released starter for each activity and version, including all designated cell source text and placeholders. Record its content hash in an instructor-controlled baseline manifest. Resolve submissions against that manifest rather than trusting an arbitrary baseline path or version supplied inside a submission. Keep older baselines for students using earlier releases. A missing, unknown, or conflicting identifier or baseline requires review.

### Student submission

Students save a copy in Drive, attempt the designated exercise or write the reflection, then download the `.ipynb` file from Colab and upload it to the corresponding LMS participation activity. Errors and unexecuted cells are acceptable. Do not require Run all, visible results, or a GitHub account for participation credit. Labels should tell students which cells to edit and to preserve the participation identifiers.

Store LMS downloads, student identifiers, review files, and grade exports outside this public repository. Use the LMS submission record to associate files with students and activities; do not infer identity from notebook content.

### Future Python validation process

1. Read submitted `.ipynb` files as notebook data and check their structure, for example with `nbformat`. Never start a kernel, execute code, evaluate expressions, render submitted HTML, or inspect whether outputs are correct.
2. Select the trusted activity baseline and starter version. Locate the designated code and reflection cells by their metadata. Flag unreadable files, invalid structures, absent or duplicate markers, wrong cell types, and uncertain baseline matches for manual review. A missing marker is not automatic evidence of nonparticipation.
3. Compare designated cell source text against the original released starter notebook for that activity and version. This comparison is mandatory before awarding automated credit; nonempty cells alone are never sufficient. Normalize line endings and ignore whitespace-only edits. Exclude unchanged instructor code, prompt text, and known starter placeholders from evidence. Opening and saving the starter, running unchanged cells, changing outputs or execution counts, and changes to notebook metadata do not count. If the designated cells remain unchanged from the starter, assign Incomplete (0%) even when they contain prewritten code. If the original starter cannot be matched reliably, flag the submission for manual review instead of awarding credit or assigning zero.
4. Look for student-added content relevant to an attempt in either designated cell. Accept an attempted expression, unfinished code, or a specific comment explaining an approach without requiring valid Python or a correct result. A reflection describing what was tried or learned also qualifies. Do not impose a minimum code length or use syntax validity as a scoring test. Placeholder-only edits, deleted starter text without an attempt, and generic responses such as `TODO` are not sufficient.
5. Propose Complete with score 100 when either cell has clear evidence of an attempt. Propose Incomplete with score 0 only when a readable, correctly matched submission clearly contains no qualifying evidence in either cell. Route uncertain relevance or ambiguous edits to manual review. Text differences alone do not prove a meaningful attempt, and automated heuristics must not judge technical correctness.
6. Produce a review CSV and have the instructor resolve flagged rows before creating an LMS import file. A review status is a processing state, not a third participation grade. Leave its score blank until review; never silently convert a review flag to zero. The reviewer applies the same binary attempt policy and can override a proposed score with a recorded reason.

Suggested review CSV columns: `student_id`, `activity_id`, `submission_id`, `starter_version`, `baseline_hash`, `status`, `score_percent`, `evidence_cell_ids`, `reason`, and `reviewer_note`. Use statuses `Complete`, `Incomplete`, and `Needs review`; score values are 100, 0, or blank pending review. Export reason codes and cell identifiers rather than student code or reflection excerpts. Preserve an audit trail of manual decisions. Write CSV with proper quoting and treat any student-supplied text as untrusted spreadsheet text rather than formulas.

After review, export only resolved grades using the LMS's required student identifier, assignment column names, and point scale. If the LMS activity is worth points rather than percentages, convert 100% to its full points and 0% to zero. Review the import preview before uploading. This does not change course weights: labs 40%, participation and checkpoints 30%, final project 30%.

### Decisions before implementation

- Verify that Colab preserves the chosen notebook and cell metadata through save and download. If it does not, document and test stable source markers before building the validator; do not fall back to cell positions.
- Choose the baseline manifest format, archive location, and release/version procedure.
- Define conservative evidence heuristics and placeholder handling using representative examples, with manual review for uncertain cases. A deterministic text comparison alone cannot establish meaning.
- Confirm LMS export/import fields, identity matching, duplicate or revised submission selection, treatment of missing submissions, and late-work handling. Missing submissions are not unreadable files and need an explicit policy.
- Set a private storage and retention procedure for submissions, baseline manifests, review records, and grade exports.

## Preview and render slides

```sh
quarto preview slides/01-first-data-analysis.qmd
quarto render slides/01-first-data-analysis.qmd
```

The render creates `slides/01-first-data-analysis.html`. Open it in a browser and check every slide for clipping, readable text, and working navigation. The HTML embeds Reveal.js resources so it can be distributed as one file. The Colab link still needs internet access, and notebook chart rendering may also load browser resources.

Commit the rendered HTML alongside its `.qmd` source. Rebuild after changing the source or GitHub owner.

## Prepare GitHub publishing

1. Choose the GitHub owner and replace `YOUR-GITHUB-USERNAME` in README.md, the notebook Markdown, the slide source, and the lab instructions. A repository search should find no remaining placeholders.
2. Render the slides again and run the local notebook checks above.
3. Clear notebook outputs before committing. Do not commit student work or private data.
4. Create an empty **public** repository named `econ3030-spring2027` in GitHub. Do not initialize it with extra files. Public access lets Colab load notebooks without a student GitHub account.
5. From this folder, run the following commands, substituting your actual owner in the remote URL. Review `git diff --cached` before committing.

```sh
git init -b main
git add README.md AGENTS.md pyproject.toml uv.lock .gitignore slides notebooks labs data assets docs
git diff --cached
git commit -m "Scaffold introductory applied data analysis course"
git remote add origin https://github.com/allanwheeler/econ3030-spring2027.git
git push -u origin main
```

These are future publishing instructions. Scaffolding does not create a remote repository or push anything.

## Verify after publishing

Open each student notebook through its direct Colab link while signed out of GitHub. Save a Drive copy, start a fresh runtime, and use **Runtime → Run all**. For the first notebook, confirm the selection has 1,000 rows, the summary has four companies with 250 observations each, and the prepared stock-price chart displays. Test hover details and date zooming. Confirm the participation cell identifiers survive saving and downloading. Confirm a downloaded `.ipynb` includes the expected results and written response. Repeat when dependencies or data change.

GitHub stores rendered HTML but does not display it as a slide website from its normal file view. For the first release, upload the rendered HTML to the course LMS as a downloadable file, or attach it to a GitHub release for download. Students open the downloaded HTML in a browser. Hosting with GitHub Pages is optional future work and is not configured here.

Share the lecture HTML, direct Colab practice link, and lab instructions in that order in the LMS. Set the actual lab due date there before assigning it.
