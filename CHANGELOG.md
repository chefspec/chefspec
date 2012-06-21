## 0.6.1 (June 21, 2012)

Features:

  - With the
    [release of Chef 10.12.0](http://www.opscode.com/blog/2012/06/19/chef-10-12-0-released/)
    the Chef versioning scheme has changed to make use of the major version
    field. The constraint on chef is now optimistic. Thanks to Robert J. Berger
    of Runa.com for flagging this issue (#28).

## 0.6.0 (May 31, 2012)

Features:

  - Service matchers extended to add support for the `:nothing` and `:enabled`
    actions. Thanks to Steve Lum (#20).
  - Added mock value for `node['languages']` to prevent failure when loading
    cookbooks that expect this attribute to have been populated by OHAI. Thanks
    to Jim Hopp (#23).
  - Matchers added for the `link` resource. Thanks to James Burgess (#25).
  - Matchers added for the `remote_file` resource. Thanks to Matt Pruitt (#26).

## 0.5.0 (February 20, 2012)

Features:

  - Thanks to Chris Griego and Morgan Nelson for these improvements:
      - Support both arrays and raw symbols for actions in the file content matcher (#14).
      - Add support for cookbook_file resources (#14).
  - Support added for `gem_package` resources. Thanks to Jim Hopp from Lookout (#16).

Bugfixes:

  - Set the client_key to nil so that Chef::Search::Query.new doesn't raise (#14). Thanks Chris Griego and Morgan Nelson.

## 0.4.0 (November 14, 2011)

Features:

  - Ruby 1.9.3 is now supported.
  - The `create_file_with_content` matcher now matches on partial content (#13). This is an API behaviour change but
  sufficiently minor and unlikely to break existing specs that I'm not bumping the major version. Thanks Chris Griego
  and Morgan Nelson from getaroom.

Bugfixes:

  - Fixed a bug in the `install_package_at_version` matcher where it would error if the package action was not
  explicitly specified (#13). Thanks Chris Griego and Morgan Nelson from getaroom.

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
