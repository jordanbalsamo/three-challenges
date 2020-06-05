# Azure Pipelines

If there was more time for this challenge I'd want to be looking at creating a set of CI/CD pipelines to enable faster iteration, catch any errors and ensure code quality. My first tool of choice - given I'll be deployed to Azure - would be Azure DevOps Pipelines, as it has good native integrations for Azure.

## TF CI - Lint and Plan

This pipelines would perform checks:
- 'tf fmt' -check. Fail if engineer has checked in code that has been formatted;
- 'tf validate' to ensure code checked in is valid;
- 'tf plan' and redirect plan to file
- create an artifact that can be gzipped and ready for CD pipeline.

## TF CD - Apply

When TF CI has run through successfully, it will trigger TF CD. TF CD will:
- download the plan artifact produced by the CI pipeline;
- depending on env, ask for approval before apply begins;
- run 'tf apply'.