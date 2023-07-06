# tfmake action

tfmake GitHub Action.

## Requirements

- tfmake >= v0.1.0-alpha.19

##  Usage

### Terraform Plan

```YAML
# tfmake install

- name: Get all changed files
  id: changed_files
  uses: tj-actions/changed-files@v35
  with:
    diff_relative: true

- name: tfmake execution
  uses: tfmake/tfmake-action@main
  with:
    tfmake_context: plan
    touch_files: ${{ steps.changed_files.outputs.all_modified_files }}
    tfmake_summary_title: "Terraform Plan"
    pull_request_number: ${{ github.event.pull_request.number }}
```

### Terraform Apply

```YAML
# tfmake install

- name: Get all changed files
  id: changed_files
  uses: tj-actions/changed-files@v35
  with:
    diff_relative: true

- name: tfmake execution
  uses: tfmake/tfmake-action@main
  with:
    tfmake_context: apply
    touch_files: ${{ steps.changed_files.outputs.all_modified_files }}
    tfmake_summary_title: "Terraform Apply"
```

### Workflow permissions

```YAML
permissions:
  contents: read
  pull-requests: write
```

### Action Inputs

| **Input**            | **Description**                              | **Required** | **Default**         |
|----------------------|----------------------------------------------|--------------|---------------------|
| tfmake_context       | The execution context; plan or apply.        | true         | -                   |
| tfmake_log_grouping  | tfmake log grouping.                         | false        | true                |
| ignore_modules       | List of modules to ignore.                   | false        | -                   |
| touch_files          | List of files to touch.                      | false        | -                   |
| tfmake_run_mode      | tfmake run mode                              | false        | -                   |
| tfmake_summary_title | tfmake summary title                         | false        | -                   |
| pull_request_number  | Pull Request number                          | false        | -                   |
| token                | GITHUB_TOKEN or Personal Access Token (PAT). | true         | ${{ github.token }} |
| working_directory    | Working directory                            | true         | -                   |

## Examples

### Drift Detection

```YAML
name: Drift Detection

on:
  schedule:
    - cron: 0 0 * * *

permissions:
  contents: read
  pull-requests: write

jobs:
  drift_detection:
    runs-on: ubuntu-20.04
    name: Drift Detection

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_wrapper: false

    - name: tfmake install
      uses: tfmake/tfmake-install-action@main
      with:
        tfmake_version: main

    - name: tfmake execution
      uses: tfmake/tfmake-action@main
      with:
        tfmake_context: plan
        tfmake_run_mode: --all
        tfmake_summary_title: "Terraform Plan"
```

## License

[MIT License](https://github.com/tfmake/tfmake/blob/main/LICENSE)
