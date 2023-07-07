#!/usr/bin/env bash

{
  set -e
  tfmake context "${TFMAKE_CONTEXT}"

  if [[ -z "${IGNORE_MODULES:-""}" ]]; then
    tfmake init
  else
    tfmake init -i "${IGNORE_MODULES}"
  fi

  # run mode "all" does not require touch
  if [[ -n "${TOUCH_FILES}" ]]; then
    tfmake touch -f "${TOUCH_FILES}"
  fi

  tfmake makefile
  set +e
}

tfmake run "${TFMAKE_RUN_MODE:-""}"
exit_code=$?

tfmake summary
tfmake gh-step-summary

if [[ -n ${PULL_REQUEST_NUMBER} ]]; then
  tfmake gh-pr-comment --number "${PULL_REQUEST_NUMBER}"
fi

exit ${exit_code}
