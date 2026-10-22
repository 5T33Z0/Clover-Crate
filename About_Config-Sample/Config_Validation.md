## 🔎 Verify your `config.plist`!

Before using a Clover configuration, verify that the `config.plist` is structurally correct and contains no formal errors.

Use [**Clover Config Checker**](https://chris1111.github.io/CloverConfigChecker/) to check your configuration for issues such as malformed entries, incorrect data types, unknown keys, and other structural inconsistencies.

## What to Check

- **Plist structure:** Ensure the file is a valid property list.
- **Key names:** Check for misspelled, unknown, or incorrectly named keys.
- **Data types:** Verify that values use the expected types, such as `Boolean`, `Integer`, `String`, `Array`, or `Dictionary`.
- **Required structure:** Ensure configuration sections and their entries follow the expected format.

> [!IMPORTANT]
> 
> A configuration that passes formal validation is not necessarily functionally correct. Validation does not guarantee that Clover recognizes or applies every setting, that the selected options are compatible with one another, or that macOS will boot successfully.
> 
> Formal validation and functional verification are separate steps. Always verify questionable settings against the Clover documentation and, where possible, confirm their behavior using Clover's preboot logs.

## Credits
- Thanks to [**chris1111**](https://github.com/chris1111) for the CloverConfigChecker Web App