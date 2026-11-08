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

**Instructor setup:** replace `YOUR-GITHUB-USERNAME` throughout this repository with the GitHub account or organization that will own the public repository. The Colab link becomes usable after the notebook is published.

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

Select `.venv/bin/python` as the notebook kernel in your editor. See [the instructor workflow](docs/instructor-workflow.md) for notebook execution checks, HTML rendering, a fresh Colab check, and manual GitHub publishing instructions. Nothing is deployed automatically.
