# Course datasets

Keep small, public course datasets here. Never add student records. The first notebook uses the downloaded Big Tech stock-price dataset below.

## Folders

- `teaching/`: a pool of five to ten standalone datasets to choose from for lectures, guided practice, and labs.
- `joins/`: related tables for teaching primary keys, foreign keys, cardinality, joins, unmatched records, and validation.
- `projects/`: three curated final project choices. Students may analyze one CSV or join two related CSVs; joins are optional.

Use descriptive lowercase filenames with hyphens, such as `cafe-sales.csv`. Name datasets by topic rather than week or lab number so they can be reused. Store related tables together in a named subfolder.

For every dataset, record its source, whether it is fictional, column meanings, units, and permission to redistribute. For related tables, also document what each row represents, the join keys, and whether those keys are unique.

## Relational skills and project pathways

Relational skills are required course content in weeks 6 through 8. A primary key identifies one row uniquely; a foreign key refers to a row in another table. Cardinality describes how many rows can match, such as one store matching many sales. Students practice joins, identify unmatched records, and validate results by checking key uniqueness, missing keys, and row counts before and after joining. Lab 3 assesses these skills and is worth 10% of the course grade.

For the final project, both pathways are eligible for full credit:

- **Single-dataset pathway:** analyze one CSV using Polars transformations and Altair visualizations.
- **Relational pathway:** join two related CSVs, validate the join, and complete the same analysis.

Grade data preparation, visualization, economic reasoning, and interpretation. The number of datasets and use of joins do not earn automatic extra credit. See each project's README for its available files, definitions, limitations, and suggested questions. The current project folders are placeholders, not ready-to-use datasets.

## Teaching catalog

| File | Topic and useful skills | Source and reuse |
| :--- | :--- | :--- |
| `teaching/cafe-sales.csv` | Fictional cafe sales; tables, filtering, formulas, grouped summaries, and bar charts | Invented for this course; freely reusable; no real people or businesses |
| `teaching/big-tech-stock-prices.csv` | Historical stock prices; selecting, filtering, indexed prices, grouped summaries, and a prepared interactive time series | [TidyTuesday, February 7, 2023](https://github.com/rfordatascience/tidytuesday/tree/main/data/2023/2023-02-07), crediting Yahoo Finance via Evan Gower's Kaggle collection; see snapshot notes below |

### Big Tech stock-price snapshot

Downloaded unchanged on November 8, 2026 from [the TidyTuesday CSV](https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2023/2023-02-07/big_tech_stock_prices.csv). These are real historical observations, not synthetic data. The release credits [Evan Gower's Kaggle dataset](https://www.kaggle.com/datasets/evangower/big-tech-stock-prices), sourced from Yahoo Finance. TidyTuesday publishes a [CC0 repository license](https://github.com/rfordatascience/tidytuesday/blob/main/LICENSE); separate upstream redistribution terms were not independently established from the available source pages. Preserve attribution and confirm upstream terms before publishing the downloaded copy.

The snapshot has 45,088 rows and eight columns covering 14 stock symbols from January 4, 2010 through January 24, 2023. Each row is one stock symbol on one recorded trading date. The pair `stock_symbol` and `date` is unique. There are no null cells, but date coverage varies across companies. SHA-256: `cb6d83535f2df947a982299bc30a9b532c7ffed9642733c6f5fb3657c4a457fc`.

| Column | Source definition and units |
| :--- | :--- |
| `stock_symbol` | Text stock ticker |
| `date` | Trading date in YYYY-MM-DD format |
| `open` | Market opening price, US dollars per share |
| `high` | Daily high price, US dollars per share |
| `low` | Daily low price, US dollars per share |
| `close` | Closing price adjusted for splits, US dollars per share, per the release dictionary |
| `adj_close` | Closing price adjusted for splits and dividend distributions, US dollars per share |
| `volume` | Shares traded that day |

The notebook selects AAPL, MSFT, META, and NVDA from January 3 through December 29, 2022, yielding 250 observations per company. Only Meta has December 30 in this snapshot, so the notebook uses the last common 2022 endpoint. It calculates `100 * adj_close / first adj_close` within each company and plots that actual Polars result. This is an adjusted price index, not company size, a forecast, or a guarantee of realized investor returns. The selected companies and period do not represent the whole stock market; price movements alone do not identify causes. Source adjustments and completeness have not been independently audited.

Until the course copy is published, the notebook reads the upstream raw CSV. After publication, its URL may be switched to `https://raw.githubusercontent.com/allanwheeler/econ3030-spring2027/main/data/teaching/big-tech-stock-prices.csv` after verifying it serves the same snapshot.

### Cafe sales columns

Each row is one fictional product sales record for a date and campus location. `sale_id` uniquely identifies a record. `quantity` is a count of items sold, not a count of transactions or customers.

| Column | Meaning | Units or format |
| :--- | :--- | :--- |
| `sale_id` | Unique record identifier | Text |
| `sale_date` | Date of sale | YYYY-MM-DD |
| `location` | Fictional campus cafe location | Category |
| `product` | Product sold | Category |
| `category` | Product group | Category |
| `quantity` | Items sold in this record | Items |
| `unit_price_usd` | Price per item | US dollars per item |

Students can calculate revenue as `quantity * unit_price_usd` and compare total revenue or items sold by category or location. This is a placeholder teaching dataset, not evidence about actual campus sales.

## Load a CSV in Colab

After the file is committed and pushed to the public GitHub repository, use its raw URL. This URL will not work until that publication step is complete.

```python
import polars as pl

url = "https://raw.githubusercontent.com/allanwheeler/econ3030-spring2027/main/data/teaching/cafe-sales.csv"
sales = pl.read_csv(url, try_parse_dates=True)
sales
```

Run the notebook's setup cell first to install the course dependencies. Students do not need a GitHub account. Update the URL if the repository owner, branch, or file path changes.
