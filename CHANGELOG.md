Changelog for ChefSpec
======================

## 1.2.0 (May 16, 2013)

Features:

  - Add support for partial files
  - Automatically check certain directories for cookbooks

## 1.1.0 (May 10, 2013)

Features:

  - Upgrade to newest version of fauxhai (@tmatilai)
  - Make `find_resource` a public method (@adamhjk)
  - Add path support (from fauxhai) (@RanjibDey)
  - Custom Chef formatter for ChefSpec (removes pesky output) (@sethvargo)

Bugfixes:

  - Remove pesky output from Chef 11

## 1.0.0 (April 22, 2013)

Features:

  - Add support for matching file content using Regular Expressions (@ketan)
  - Add support for `ruby_block` matcher (Andrey Vorobiev)
  - Use Fauxhai for node attributes (see 4529c10)
  - Moved `test` and `development` into gemspec for transparency
  - Improve message logging and testing (@tmatilai)
  - Chef 11 compatibility (still Chef 10 compatible)
  - Accept and document new RSpec "expect" syntax
  - Attribute matchers for various providers (@bjoernalbers)
  - Add execute_{bash,csh,perl,python,ruby}_script matchers (@mlafeldt)
  - Add group and user resource matchers (@gildegoma)
  - Add support for `yum_package` (Justin Witrick)
  - Add ISSUES.md
  - Add CONTRIBUTING.md
  - Relax gemspec constraints (@juliandunn)
  - Improve documentation and examples

Bugfixes:

  - Fix Rubygems/Bundler 2.0 compatibility issues
  - Upgrade to newest RSpec
  - Fix Chef 11 incompatibility
  - Various documentation fixes

## 0.9.0 (November 10, 2012)

Features:

  - Support added for the `user` resource (#6). Thanks Ranjib Dey.
  - Support for making assertions about notifications added (#49). Thanks to
    Ranjib Dey.
  - New `include_recipe` matcher added (#50). Thanks Ranjib Dey.
  - Support added for the Windows `env` resource (#51). Thanks Ranjib Dey.
  - Convenience methods for common resources added to `ChefRunner` (#51).
    Thanks Ranjib Dey.
  - Further resource convenience methods added (#60). Thanks to Ketan
    Padegaonkar.
  - Support for the `:disable` action added to the service resource (#67).
    Thanks to Chris Lundquist.
  - Add a matcher to assert that a service is not running on boot (#58). Thanks
    to Ketan Padegaonkar.
  - Support added for the `chef_gem` resource (#74). Thanks to Jim Hopp.

Bugfixes:

  - Avoid failure if template path is not writable (#48). Thanks to Augusto
    Becciu and Jim Hopp.
  - Style fix for the README (#55). Thanks Greg Karékinian.
  - Ensure notification assertions work where the resource name contains
    brackets (#57). Thanks Sean Nolen.
  - Unit tests updated to explicitly specify attribute precedence as required
    from Chef 11 (#70). Thanks Mathias Lafeldt.
  - Documentation added to the README for the `create_remote_file` matcher
    (#71). Thanks Mathias Lafeldt.
  - Clarify that `create_file_with_content` matches on partial content (#72).
    Thanks Mathias Lafeldt.

## 0.8.0 (September 14, 2012)

Features:

  - LWRP support added (#40). You can now make assertions about the resources
    created by a provider by telling chefspec to [step into a provider
    implementation](https://github.com/acrmp/chefspec/tree/v0.8.0#writing-examples-for-lwrps).
    Thanks to Augusto Becciu for implementing this feature.
  - Updated for compatibility with Chef 10.14. Thanks Augusto Becciu.

Bugfixes:

  - Template paths are no longer hard-coded to live under `default` (#32).
    Thanks Augusto Becciu.

## 0.7.0 (August 27, 2012)

Features:

  - Cron resource support added (#33). Thanks Alexander Tamoykin.
  - RSpec dependency
    [bumped to 2.11](https://github.com/rspec/rspec-core/blob/b8197262d143294bf849ab58d1586d24537965ab/Changelog.md)
    which has
    [named subject](http://blog.davidchelimsky.net/2012/05/13/spec-smell-explicit-use-of-subject/)
    support (#37). Thanks Doug Ireton.

Bugfixes:

  - Correctly infer the default `cookbook_path` on Windows (#38). Thanks Torben
    Knerr.

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
