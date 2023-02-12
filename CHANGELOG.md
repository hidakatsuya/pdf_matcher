## 2.1.0

### Bug Fixes

- Fixes an issue where it would appear diff-pdf ran successfully but actually returned an erroneous exit code. Now raises an error if this occurs.

## 2.0.0

### Breaking Changes

- Delete (not keep) the difference PDF when the PDFs are matched [44b05f8](https://github.com/hidakatsuya/pdf_matcher/commit/44b05f8c0df8d2429e3b6c50e2fbb02ed87ee139)

## 1.0.1

### Bug Fixes

- Fixed Encoding::UndefinedConversionError: "\xFF" from ASCII-8BIT to UTF-8 [63e8605](https://github.com/hidakatsuya/pdf_matcher/commit/63e860516d77863978a1b22c8674aa2e78572613)

## 1.0.0

The first release. See [README.md](README.md) for detailed instructions.
