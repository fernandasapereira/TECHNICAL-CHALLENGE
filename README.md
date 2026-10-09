# Technical Challenge – QA Automation

Robot Framework and SeleniumLibrary tests for file upload, file download, and JSON comparison.

## Project Structure

| Folder | Purpose |
|---|---|
| `tests/` | The suites. Names start with `1-`, `2-`, and `3-` so the execution order stays fixed. |
| `resources/` | Keywords and page actions. The tests stay short. |
| `data/` | The original CSV and the JSON files. |
| `downloads/` | Where Chrome saves downloaded files. Cleared at the start of the download suite. |
| `output/` | Robot results and the timestamped CSV copy. Only `log.html` is kept in Git. |

The browser opens in the suite setup and closes in the suite teardown, so tests in the same suite share one page.

## Suite 1 – Upload

File: `tests/1-file_upload.robot`  
Page: https://the-internet.herokuapp.com/upload

**Upload CSV And Validate Result** (`smoke`, `regression`)

Before the browser opens, setup copies `data/sample_upload.csv` to a name that includes the current date and time, for example `sample_upload_20261009_141530.csv`.

The test uploads that copy and checks two things on the page: the message `File Uploaded!` and the file name.

The date and time are part of the name because the download page is public and already contains other files named `sample_upload.csv`. A unique name lets suite 2 download the file from this run. The check waits for the text on the new page. The heading that exists before submit is replaced when the page reloads, so the test does not wait on that old element.

The name is written to `output/last_uploaded_file.txt` only after this test passes. Any previous marker is removed at the start of the suite.

## Suite 2 – Download

File: `tests/2-file_download.robot`  
Page: https://the-internet.herokuapp.com/download

Setup clears `downloads` once, before the first test, and configures Chrome to save files there without a prompt.

**Download First Available File And Validate It Locally** (`smoke`, `regression`)

Clicks the first link in the list. The goal is to download whichever file is first.

The file name is not taken from the link text. Some links on this page contain characters that Windows does not allow in a file name, and Chrome then saves the file under a different name. The keyword waits until a file that does not end in `.crdownload` appears in `downloads`. That suffix is Chrome's temporary file while the download is still in progress. The test then checks that the file exists and is not empty.

**Download Sample Txt And Validate It Locally** (`regression`)

Downloads a fixed file, `sample.txt`, and checks that it exists in the folder and is not empty. The link is matched by its exact text so similar file names are not selected.

**Download Uploaded CSV And Validate Content** (`regression`)

Reads the name saved by suite 1, downloads that CSV, and compares its content with the copy that was uploaded. Windows and Unix line breaks are treated as the same.

This test runs only when **Upload CSV And Validate Result** has passed. The marker file is written only in that case. If the upload test fails, the marker is missing and this download is skipped. Both suites must run in the same execution, suite 1 before suite 2.

## Suite 3 – JSON

File: `tests/3-json_comparison.robot`

Setup reads `data/json1.json` and `data/json2.json` once. The tests use that data and do not open those two files again.

`json1` and `json2` have the same content. `json3` has the same `suite` and `environment`, and a different `checks` object.

**JSON Files Contain The Same Keys And Values** (`smoke`, `regression`)

Full comparison of `json1` and `json2`: the same keys and the same values.

**Selected JSON Fields Are Equal** (`regression`)

Partial comparison between `json1` and `json3`. Only `suite` and `environment` are checked. `checks` differs and is left out, so this test shows that a partial comparison does not require the whole file to match.

**JSON Checks Differ Between File 1 And File 3** (`regression`)

Checks that the `checks` object in `json1` is different from the one in `json3`. The test passes because the values are not equal.



## How to Run 

## Set up the virtual environment

Python 3.10 or higher and Google Chrome are required. Open a terminal in the project folder and run:

```powershell
python -m venv .venv
```


NOTE: If PowerShell blocks the activation script, allow it for the current window only by running the command: 

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```


Activate the environment, install the test libraries, and confirm Robot Framework:

```powershell
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
robot --version
```

`robot --version` should report Robot Framework 7.5. The prompt shows `(.venv)` while the environment is active. A new terminal needs the activation command again. The `.venv` folder stays on this machine and is not committed.



## Run

From the project folder, with the virtual environment active:

```powershell
.\.venv\Scripts\Activate.ps1
robot --outputdir output tests
```

This runs the three suites in order and writes a single `output/log.html`. That file is the execution output required for submission.

To run one tag:

```powershell
robot --include smoke --outputdir output tests
robot --include regression --outputdir output tests
```

`smoke` is the main path of each suite. `regression` includes those tests and the extra ones.
