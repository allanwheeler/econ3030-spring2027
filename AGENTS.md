# Course scope

This repository is econ3030-spring2027, an introductory applied data analysis course at CSU Bakersfield. Do not expand it into a full semester without a request.

# Teaching model

- Preserve the sequence: lecture → guided practice → graded lab.
- Assume no programming prerequisites. Explain new terms in plain language.
- Students work exclusively in Google Colab. Never require local installation or a GitHub account.
- Use Python, Polars, and Altair. Do not add SQL, DuckDB, APIs, or unnecessary tools.
- Every student notebook must have a direct Colab link, a setup cell, and clear Markdown instructions.
- Keep examples small and use fictional or explicitly sourced public data. Never commit student records.
- Labs should assess interpretation as well as code. State submission instructions and a rubric.

# Instructor workflow

- Author locally in VS Code or Positron using uv for Python dependencies.
- Use Quarto Reveal.js for slides and publish the rendered HTML alongside the source.
- Keep notebook outputs cleared in Git. Execute notebooks before publishing and test them again in a fresh Colab runtime.
- Keep dependency ranges in notebook setup cells aligned with pyproject.toml.
- Update direct Colab links if paths or the GitHub owner change.
- Do not deploy or publish without an explicit request.

# Communication

Be concise. Use bullets when helpful, but never as inline separators. Do not use em dashes, en dashes, or hyphens as sentence punctuation. Do not invoke skills unless explicitly asked.
