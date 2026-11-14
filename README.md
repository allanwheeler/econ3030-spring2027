# ECON 3030 | Spring 2027

Introductory applied data analysis at **California State University, Bakersfield**.

Learn to ask a question, organize a small dataset, make a chart, and explain what the evidence supports. No programming experience is assumed.

## For students

You will do all coding in **Google Colab**, in your browser. You do not need to install Python, set up a computer, or create a GitHub account. A Google account is needed to save your own notebook in Drive.

1. Read the lecture slides shared by your instructor.
2. Open the guided practice notebook in Colab.
3. Choose **File → Save a copy in Drive** so your edits are saved.
4. Read each Markdown section and run code cells from top to bottom using the play buttons.
5. Complete the separate lab and submit your work through the course LMS.

[Open example guided practice in Colab](https://colab.research.google.com/github/allanwheeler/econ3030-spring2027/blob/main/notebooks/01-first-data-analysis.ipynb)

**Instructor setup:** the repository owner is `allanwheeler`. Colab links require the referenced branch and notebook to be publicly accessible.

## Example learning sequence

| Stage | Material | Purpose |
| :--- | :--- | :--- |
| Lecture | [Slide source](slides/01-first-data-analysis.qmd) | Introduce rows, columns, averages, and charts using a fictional warm-up |
| Guided practice | [Notebook](notebooks/01-first-data-analysis.ipynb) | Filter historical stock prices, calculate indexes with Polars, and run a prepared Altair chart |
| Graded lab | [Example assignment](labs/01-first-data-analysis.md) | Apply the same ideas independently and explain a result |

This is a starter repository with one example, not a full semester.

## Repository layout

```text
slides/       Quarto Reveal.js sources and rendered HTML
notebooks/    Student notebooks with direct Colab links
labs/         Assignment instructions and rubrics
data/         Small teaching datasets when needed
assets/       Shared images and other course assets
docs/         Instructor workflow and publishing instructions
```

The first guided notebook reads a public historical stock-price CSV from TidyTuesday; a downloaded copy and source notes are in [the data catalog](data/README.md). It requires internet access but no API or account. The existing slides and example lab still use the fictional study-hours warm-up; the example lab has not yet been adapted to the revised notebook.

## For the instructor

Author locally in VS Code or Positron. Use **uv** for Python dependencies and install **Quarto** separately for slides. Students do not perform these steps.

```sh
uv sync
uv run python -c "import polars, altair; print(polars.__version__, altair.__version__)"
quarto preview slides/01-first-data-analysis.qmd
```

Select `.venv/bin/python` as the notebook kernel in your editor. See [the instructor workflow](docs/instructor-workflow.md) for notebook execution checks, HTML rendering, a fresh Colab check, and manual GitHub publishing instructions. Pushes to `course-website` publish the website automatically through GitHub Actions.

## Course website preview

The initial website lives on `course-website`. It has Home, Schedule, and Resources pages, plus a Slides menu. The schedule uses tentative topics from the local planning draft; Canvas remains authoritative for official course administration. The older Python example lab is not advertised as Excel Lab 1.

Use Quarto **1.10.18** (also pinned in CI):

```sh
quarto preview
quarto render
```

On this computer, `/Applications/quarto/bin/quarto` is the current installation. If `quarto --version` reports `0.9.399`, use the full path above or fix your PATH. The website build does not install Python packages or execute notebooks or slides. `_site/` is generated and ignored. Every build checks its publication file list using `scripts/check-site.sh`.

### Add materials

1. Write a Reveal.js presentation in `slides/`. Keep the existing slide format and inline Altair export conventions.
2. Render it separately, using the separate `slides/_quarto.yml` project:

   ```sh
   uv sync
   uv run python -m ipykernel install --prefix .venv --name python3 --display-name "ECON 3030 local"
   JUPYTER_PATH="$PWD/.venv/share/jupyter" QUARTO_PYTHON="$PWD/.venv/bin/python" quarto render slides/NAME.qmd
   ```

The explicit kernel path avoids selecting an unrelated Anaconda installation. Register the local kernel again if you recreate `.venv`.

3. Check the slide HTML and Altair chart in a browser. Commit both the source and self-contained HTML.
4. Add the HTML path to `_quarto.yml` under `project.resources` and the Slides menu, and to the allowed paths and required files in `scripts/check-site.sh`.
5. Add slide links and notebook Colab links to `schedule.qmd`. The preview notebook link uses `https://colab.research.google.com/github/allanwheeler/econ3030-spring2027/blob/course-website/notebooks/NAME.ipynb`. Keep each notebook's own direct link aligned when releasing it on a different branch.
6. For a downloadable dataset, confirm redistribution terms and document its source, units, and definitions. Add only that file to the resources and publication check. The stock CSV is deliberately excluded from website output while upstream terms remain unresolved.
7. Render and inspect `_site/`, then commit and push `course-website`. The website publishes automatically on push to `course-website`.

### Publish with GitHub Pages

The public course site is https://www.allanwheeler.com/econ3030-spring2027/. GitHub Pages inherits the account website's custom domain.

GitHub Actions builds and publishes the checked `_site/` output on every push to `course-website`. No merge into `main` is needed. In repository **Settings → Pages**, the source is **GitHub Actions**. The workflow installs Quarto 1.10.18, renders only the three website pages, checks the publication file list, and deploys the result.

```sh
git switch course-website
git push origin course-website
gh run list --branch course-website --workflow website.yml
```

Wait for the workflow to succeed and open the site before sharing a new version. The repository is public so students can open the linked notebooks in Colab. Keep local instructor solutions and private planning files untracked; the website publication check does not hide files in a public repository's history.

Reference: [GitHub custom Pages workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages).

### Adjust the website appearance

The website layers `theme.scss` over the selected Quarto theme in `_quarto.yml`. It uses neutral colors, system fonts, subtle borders, and rounded controls inspired by Basecoat while retaining Quarto's Bootstrap markup. No Basecoat, Tailwind, or additional JavaScript is installed.

Edit `theme.scss` for colors, fonts, and Bootstrap component defaults. Edit `styles.css` for navigation, title, table, and spacing details. Run `quarto preview` while editing. To compare the built-in theme, temporarily remove `theme.scss` from the theme list and comment out `css: styles.css`. Reveal.js slides use their separate configuration.
