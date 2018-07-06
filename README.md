Use curl to mimic upload of the plugin through front-end rather than using jenkins-cli.jar for various reasons:
1) cli doesn't support versions when using plugin short name so need to put the full uri, but
2) cli with full uri - doesn't support redirects, so we need to figure out mirrors manually, which could potentially change
3) finally and most importantly cli doesn't download dependencies!
