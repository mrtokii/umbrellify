# Umbrellify
[![Gem Version](https://badge.fury.io/rb/umbrellify.svg)](https://badge.fury.io/rb/umbrellify)

<p align="center">
  <img width="320" height="320" src="https://user-images.githubusercontent.com/15659755/77676503-7a444880-6f9f-11ea-9c05-d3464a282796.png">
</p>

*Umbrellify is not stable and still in development.*

Umbrellify is a tool that combines frameworks into an alias. It uses `@_exported` annotation to provide a single import declaration, which exports multiple other imports. The only supported language is Swift.

Here is what Umbrellify does:

- Creates a new target in your project
- Adds selected imports in the target's file and exports them
- Scans your source code and replaces selected imports with created target's import

## Installation

Umbrellify can be installed through RubyGems, the Ruby package manager. Run the following command to install:
```bash
$ gem install umbrellify
```

## Usage

To use Umbrellify in your Xcode project, you first need to create a configuration file, named `Umbrellifile` in your project's directory. The contents of `Umbrellifile` follow *YAML* syntax.

An example configuration is showed below:

```yaml
umbrella_target_name: MyAppCoreFrameworks
main_target_name: MyApp
substitute_managed_imports_only: false
project_path: MyApp.xcodeproj
source_path: ./MyApp
managed_targets:
  - Core
  - Models
  - Resources
```

## Config structure

### `umbrella_target_name` 
Name of the created framework.

### `main_target_name` 
Name of your app's target that will depend on the created framework (typically, it is your Application target).

### `substitute_managed_imports_only` 
Substitute import statements in source files only if all of the managed imports are present. 
For example, here is a source file header:

```swift
import Foundation
import Core
import Models

class MyModel {
...
```

If `substitute_managed_imports_only` is set to `true`, the header will stay untouched hence the missing *Resources* import.
If the option is set to `false`, the header becomes modified:

```swift
import Foundation
import MyAppCoreFrameworks

class MyModel {
...
```

### `project_path`
Path to your .xcodeproj file.

### `source_path`
Path to your source files to be modified (typically, it should be your app target's main bundle path). If the option is not set, the path is default to current directory.

### `managed_targets`
List of target names that should be included in the created framework.

## Usage

Ubrellify is designed to be used constantly throughout the development process. 
Each time it is launched, Umbrellify updates its created target contents and scans source files for the presense of new managed import declarations.

To use Umbrellify, run the following command in the directory where your *Umbrellifile* is:

```bash
$ umbrellify
```

## LICENSE

These works are available under the MIT license. See the [LICENSE](https://github.com/mrtokii/umbrellify/blob/master/LICENSE.md) file for more info.
