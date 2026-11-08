# Course scope

This repository is econ3030-spring2027, an introductory applied data analysis course at CSU Bakersfield. Do not expand it into a full semester without a request.

# Teaching model

- Preserve the sequence: lecture → guided practice → graded lab.
- Assume no programming prerequisites. Explain new terms in plain language.
- Lab 1 uses Excel tables, formulas, and pivot tables. All Python work uses Google Colab. Never require a local Python installation or a GitHub account.
- Use Excel for Lab 1 and Python, Polars, and Altair for subsequent labs and the final project. Do not add SQL, DuckDB, APIs, or unnecessary tools.
- Every student notebook must have a direct Colab link, a setup cell, and clear Markdown instructions.
- Follow [Visual Payoff](docs/instructor-workflow.md#visual-payoff) in relevant early Colab lecture notebooks, guided exercises, and labs: culminate in a prepared Altair chart using the students' Polars results, then gradually shift chart authorship to students as visualization is taught. This is a design pattern, not an additional grading requirement.
- Future guided notebooks must include a standardized participation code exercise and optional Markdown reflection near the end, using the stable metadata and baseline conventions in [the participation workflow](docs/instructor-workflow.md#guided-notebook-participation). Award Complete (100%) for a meaningful attempt in either cell, even with code errors; otherwise Incomplete (0%). Do not grade correctness or unchanged starter content. Flag ambiguous submissions for review. Keep this separate from competency-based lab rubrics.
- Keep examples small and use fictional or explicitly sourced public data. Never commit student records.
- Labs should assess interpretation as well as spreadsheet or code skills. State submission instructions and a rubric.

# Instructor workflow

- Author locally in VS Code or Positron using uv for Python dependencies.
- Use Quarto Reveal.js for slides and publish the rendered HTML alongside the source.
- Keep notebook outputs cleared in Git. Execute notebooks before publishing and test them again in a fresh Colab runtime.
- Keep dependency ranges in notebook setup cells aligned with pyproject.toml.
- Update direct Colab links if paths or the GitHub owner change.
- Do not deploy or publish without an explicit request.

# Altair charts in slides

- In Quarto Reveal.js slides, display each Altair chart with `HTML(chart.to_html(inline=True, fullhtml=False, output_div="unique-chart-id"))`, importing `HTML` from `IPython.display`. Use a different `output_div` ID for every chart in the document.
- Embed the chart libraries with `inline=True` so charts do not depend on downloading JavaScript when the slides open. Keep `vl-convert-python` in the local development dependencies for this export.
- Use explicit chart dimensions, such as `.properties(width=900, height=340)`, sized to fit the slide. Avoid `width="container"` in slides because hidden slides can interfere with width measurement.
- Apply this export pattern only to slides. Keep the normal Altair display workflow in Google Colab notebooks.
- After chart changes, execute and render the slide source, then check the chart in a browser. Keep the rendered HTML alongside the source.

# Instructor solutions

- Keep instructor solutions local in `solutions/` directories.
- Never move, copy, or commit instructor solutions, including excerpts, answers, completed code, or notebook outputs, into public-facing materials such as student notebooks, lab instructions, slides, documentation, rendered HTML, or published assets.
- Never force-add instructor solutions to Git or bypass the `**/solutions/` ignore rule.
- `.gitignore` prevents ordinary Git tracking. It is not a security boundary. Check that public-facing changes and publication artifacts contain no instructor solutions before committing or publishing.

# Communication

Be concise. Use bullets when helpful, but never as inline separators. Do not use em dashes, en dashes, or hyphens as sentence punctuation. Do not invoke skills unless explicitly asked.
