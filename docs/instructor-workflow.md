# Instructor workflow

Students use Colab only. These local instructions are for the instructor in VS Code or Positron.

## Local authoring

Install uv and Quarto using their official installers. From the repository root, run:

```sh
uv sync
```

uv creates `.venv` and uses `uv.lock` for reproducible local installs. Commit the lockfile. Select `.venv/bin/python` in your editor’s notebook kernel picker. The notebook setup cell uses `%pip` for Colab; use `uv sync` to manage local packages and skip that setup cell locally. Python 3.12 is a suitable interpreter for local work.

Keep the dependency ranges in the Colab setup cell and `pyproject.toml` aligned. Colab resolves packages at runtime and does not use the local lockfile. Test in Colab before each release.

## Test the notebook locally

From the repository root, run this script in your terminal. It validates the notebook, executes its Python analysis cells in a temporary copy, and checks the expected table, mean, and chart specification. It skips the Colab installation command and renderer selection. It never saves execution outputs into the source notebook.

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
assert study.shape == (5, 2)
assert mean_hours.item() == 4.0
spec = chart.to_dict()
assert spec["mark"]["type"] == "bar"
assert spec["encoding"]["y"]["field"] == "study_hours"
'''))
NotebookClient(nb, timeout=120, kernel_name="python3").execute()
print("Notebook validated and analysis checks passed.")
PY
```

This checks Python execution and the chart specification. It does not verify the Colab interface or visually inspect the chart.

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

Open each student notebook through its direct Colab link while signed out of GitHub. Save a Drive copy, start a fresh runtime, and use **Runtime → Run all**. Confirm the table has five rows, the mean is 4.0, and the bar chart displays. Confirm a downloaded `.ipynb` includes the expected results and written response. Repeat when dependencies or data change.

GitHub stores rendered HTML but does not display it as a slide website from its normal file view. For the first release, upload the rendered HTML to the course LMS as a downloadable file, or attach it to a GitHub release for download. Students open the downloaded HTML in a browser. Hosting with GitHub Pages is optional future work and is not configured here.

Share the lecture HTML, direct Colab practice link, and lab instructions in that order in the LMS. Set the actual lab due date there before assigning it.
