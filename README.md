# pulfa-restricted
Stand-alone, statically-generated html Finding Aid for content-restricted collections.

XSL transformation requires the ```Saxon-EE 9.4.0.6``` transformer.

The following parameters are required:

1. xslt.base-uri
2. xslt.record-id

To test html output:

1. copy contents of `assets` into `test`
2. download EAD into `test`
3. apply svp.xsl to EAD
