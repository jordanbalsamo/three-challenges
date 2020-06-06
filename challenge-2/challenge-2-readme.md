# Challenge #2
 
We need to write code that will query the meta data of an instance within AWS and provide a json formatted output. The choice of language and implementation is up to you.
 
Bonus Points
 
The code allows for a particular data key to be retrieved individually
 
Hints
- Aws Documentation
- Azure Documentation
- Google Documentation

# Approach

Initial thoughts are to return all relevant metadata for a VM instance according to an identifer supplied by the user of the script.

This will be done via bash, which will act as a wrapper around the Azure / AWS / GCP CLIs.

1) prompt user for inputs (cloud provider, instance identifier);
2) error handle;
3) invoke CLI command relevant to chosen cloud provider;
<br/>...
4) could go one step further and use [jq](https://stedolan.github.io/jq/) to prettify JSON output.

# Usage

Please authenticate to your preferred cloud provider, prior to running this script. For example:

```az login```
<br/>
\- OR -
<br/>
```aws configure```

This script can be run by issuing the following command to a bash-friendly terminal:

```./query-vm-metadata.sh```

## Notes

Due to time restrictions, I've mocked the JSON output, but all CLI commands should yield JSON output metadata for a given VM identifier.