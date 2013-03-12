Contributing to ChefSpec
========================
Pull requests are merged via Github, you can find the documentation about how to fork a repository and start contributing to ChefSpec here [https://help.github.com/articles/fork-a-repo](https://help.github.com/articles/fork-a-repo).

All contributions are welcome to be submitted for review for inclusion, but before they will be accepted, we ask that you follow these simple steps:

* [Coding standards](#coding-standards)
* [Testing](#unit-testing)
* [Documentation](#documentation)

Also, please be patient as not all items will be tested or reviewed immediately by the core team.

Pleas be receptive and responsive to feedback about your additions or changes. The core team and/or other community members may make suggestions or ask questions about your change. This is part of the review process, and helps everyone to understand what is happening, why it is happening, and potentially optimizes your code.

If you're looking to contribute but aren't sure where to start, check ou the [open issues](https://github.com/acrmp/chefspec/issues?state=open).

Coding Standards
----------------
The submitted code should be compatible with the standard Ruby coding guidelines. Here are some additional resources:

 * [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
 * [Github Styleguide](https://github.com/styleguide/ruby)

There is a tool called [Cane](https://github.com/square/cane) that allows you to validate your code's ABC complexity and documentation.

Unit Testing
------------
Whether your pull request is a bug fix or introduces new classes or methods to the project, we kindly ask that you include tests for your changes. Even if it's just a small improvement, a test is necessary to ensure the bug is never re-introduced.

We understand that not all users submitting pull requests will be proficient with RSpec. The maintainers and community as a whole are a helpful group and can help you with writing tests. The [Better Specs](http://betterspecs.org/) site should provide some helpful resources to get you started.

Documentation
-------------
Documentation is a crucial part to ChefSpec, especially given its broad depth of features. All documentation is currently placed in the main `README.md` file at the root of the repository and uses Github Flavored Markdown.

When contributing new features, please add notes and examples about the new features to the existing `README.md` file.

Any additional matchers will require a set of examples in the README.

The documentation should explain how a developer should should be able to get started testing with ChefSpec. The documentation should provide several simple examples.

---
This contributing guide is based off of the [Joomla Contributing Guide](https://raw.github.com/joomla/joomla-framework/master/CONTRIBUTING.markdown).