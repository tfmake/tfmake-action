#!/usr/bin/env bash

{
  set -e
  tfmake context "${TFMAKE_CONTEXT}"

  if [[ -n "${IGNORE_MODULES}" ]]; then
    tfmake init -i "${IGNORE_MODULES}"
  else
    tfmake init
  fi

  tfmake touch -f "${FILES}"
  tfmake makefile
  set +e
}

tfmake run "${TFMAKE_RUN_MODE:-""}"
exit_code=$?

tfmake mermaid
tfmake summary "${TFMAKE_SUMMARY_OPTIONS:-""}"
tfmake gh-step-summary

if [[ -n ${PULL_REQUEST_NUMBER} ]]; then
  tfmake gh-pr-comment --number "${PULL_REQUEST_NUMBER}"
fi

exit ${exit_code}
