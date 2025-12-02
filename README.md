# Replication Package – From Pandemic to Present: How COVID-19 Shaped Collaboration in Open Source Projects

This repository contains the data, queries, and analysis code used in our study:

> McDaniel et al. (2025). *From Pandemic to Present: How COVID-19 Shaped Collaboration in Open Source Projects.*

The goal of this package is to allow others to reproduce the GitHub event extraction,
statistical analysis, and figures reported in the paper.

## 1. Contents

- `sql/01_events_by_day_all_repos.sql`  
  BigQuery SQL query to extract daily counts of 14 GitHub event types
  (2017–2019 and 2023–2025).

- `data/raw/gh_events_2017_2025.csv`  
  CSV of daily event counts exported from BigQuery using the above query. Columns:
  `event_date, year, type, total_events`.

- `notebooks/covid_collab_BigQuery.ipynb`  
  Jupyter/Colab notebook containing all analysis steps. This is the **primary**
  artifact for reproducing the results. It:
  - loads `gh_events_2017_2025.csv`,
  - adds event groups and pre/post labels,
  - computes descriptive statistics,
  - generates all figures (solo development, core team, code review, issues, community),
  - runs segmented linear regression and Augmented Dickey–Fuller (ADF) tests.

- `data/processed/`  
  Derived tables and summary statistics produced by the notebook
  (e.g., figures, slopes per event, ADF results, group-level summaries).

- `src/analysis.py` (optional)  
  Minimal Python script version of the core analysis for users who prefer
  running code locally instead of using Colab. The notebook remains the
  authoritative reference.

## 2. How to re-extract the dataset from GH Archive (BigQuery)

1. Open [Google BigQuery](https://console.cloud.google.com/bigquery).
2. Ensure the public dataset `githubarchive.day` is available.
3. Create (or select) a dataset in your project, e.g. `covid_oss_replication`.
4. Open a new SQL editor tab and paste the contents of
   `sql/01_events_by_day_all_repos.sql`.
5. Run the query. This will aggregate daily counts for the 14 selected event types
   across:
   - 2017–2019 (pre-COVID window)
   - 2023–2025 up to 2025-10-27 (post-COVID window)
6. Save the results as a table (e.g., `covid_oss_replication.events_daily`).
7. Export the table to CSV and save it as:

   `data/raw/gh_events_2017_2025.csv`

   The notebook assumes this filename and column schema.

## 3. Reproducing the analysis using `covid_collab_BigQuery.ipynb` (Colab)

1. Open `notebooks/covid_collab_BigQuery.ipynb` in Google Colab.
2. Upload `data/raw/gh_events_2017_2025.csv` to the Colab environment
   (or mount your Google Drive and update the path in the notebook).
3. Run all cells in order.

The notebook produces:

- Descriptive statistics (event first/last occurrence, total counts).
- Event group descriptions (Solo Development, Core Team, Code Review, Issues, Community).
- Monthly trend plots for:
  - all event types combined, and
  - each collaboration group (solo dev, core team, code review, issues, community).
- Linear regression slopes for pre- and post-COVID windows and their relative change.
- Augmented Dickey–Fuller test statistics and p-values for each event type.

Several CSV files (e.g., `events_overview_table2.csv`, `event_slopes_pivot.csv`,
`adf_results_by_event.csv`, group-specific slope and ADF tables) and PNG figures
are written out. When running locally, place them in `data/processed/`; in Colab,
you can download them and store them in that folder in this repository.

## Environment Requirements

The analysis notebook expects the following environment:

- Python 3.10+
- pandas ≥ 2.0
- numpy ≥ 1.21
- scipy ≥ 1.10
- matplotlib ≥ 3.7
- statsmodels ≥ 0.14
- Jupyter / Google Colab

BigQuery:
- Google Cloud project with access to `githubarchive.day` public dataset

## Citation

If you use this replication package, please cite:

McDaniel, A., Paplow, P., Valdez, C., & Garcia, S. (2025).  
*From Pandemic to Present: How COVID-19 Shaped Collaboration in Open Source Projects.*
