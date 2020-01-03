# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- This CHANGELOG file.
- README file. Currently contains a brief overview of the project and a screenshot from the walk_around demo.
- SpatialMarkerManagerDown node.

### Removed

- Export directory (using `.gitignore`). This was an oversight and should never have been included.

### Changed

- Moved the different (mutually exclusive) position mapping logic from the SpatialMarkerManager node to inhereted nodes and renamed it to SpatialMarkerManagerBase. The SpatialMarkerManagerBase node now acts as a base class and can be easily extended by overriding the `_map()` function.
