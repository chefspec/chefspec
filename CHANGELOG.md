## 0.3.0 (October 2, 2011)
Features:

  - [Added new matcher](https://www.relishapp.com/acrmp/chefspec/docs/write-examples-for-templates) `create_file_with_content` for verifying Chef `template` resource generated content.
  - [Knife plugin](https://www.relishapp.com/acrmp/chefspec/docs/generate-placeholder-examples) added to generate placeholder examples.

## 0.2.1 (September 21, 2011)
Bugfixes:

  - Fixed typo in 0.2.0 botched release. Pro-tip: run your tests.

## 0.2.0 (September 21, 2011)

Features:

  - Significantly improved performance by not invoking OHAI.
  - ChefRunner constructor now accepts a block to set node attributes.
  - ChefRunner constructor now takes an options hash.
  - Converge now returns a reference to the ChefRunner to support calling converge in a let block.

Bugfixes:

  - Removed LWRP redefinition warnings.
  - Reset run_list between calls to converge.
  - Readable to_s output for failed specs.

## 0.1.0 (August 9, 2011)

Features:

  - Support for Chef 0.1.x (#2)
  - Support MRI 1.9.2 (#3)

Bugfixes:

  - Added specs.

## 0.0.2 (July 31, 2011)

Bugfixes:

  - Corrected gem dependencies.

## 0.0.1 (July 31, 2011)

Initial version.
