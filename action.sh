#!/usr/bin/env bash

{
  set -e

  tfmake context "${TFMAKE_CONTEXT}"
  tfmake init
  tfmake touch -f "${FILES}"
  tfmake makefile
}

tfmake run "${TFMAKE_RUN_MODE:-""}"
exit_code=$?

tfmake mermaid
tfmake summary "${TFMAKE_SUMMARY_OPTIONS:-""}"
tfmake gh-step-summary

if [[ -n ${PULL_REQUEST_NUMBER} ]]; then
  tfmake gh-pr-comment "${PULL_REQUEST_NUMBER}"
fi

exit ${exit_code}
