# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About Amber

Amber is a programming language that compiles to Bash. It's a high-level language that makes shell scripting easier and safer. The compiler is written in Rust and follows a classic multi-phase pipeline: tokenization → parsing → type checking → translation → optimization → post-processing.

## Common Commands

### Building
```bash
cargo build                    # Build debug binary
cargo build --release          # Build optimized binary
```

### Testing
```bash
cargo test                                    # Run all tests
cargo test validity::test_name                # Run specific test
cargo test --all-targets --all-features       # Run all tests (CI mode)

# Test with specific Bash version (requires Docker)
AMBER_TEST_STRATEGY=docker AMBER_TEST_ARGS="exec test_container bash" cargo test
```

### Running Amber Code
```bash
cargo run -- eval "echo 'Hello'"              # Evaluate code fragment
cargo run -- run script.ab                    # Run Amber script
cargo run -- build input.ab output.sh         # Compile to Bash
cargo run -- check script.ab                  # Check for errors
cargo run -- test path/to/tests               # Run Amber tests
```

### Linting
```bash
cargo clippy --all-targets --all-features -- -D warnings
```

### Development Flags
```bash
AMBER_DEBUG_PARSER=1 cargo run -- build script.ab   # Debug parser output
AMBER_DEBUG_TIME=1 cargo run -- build script.ab     # Show timing info
AMBER_NO_OPTIMIZE=1 cargo run -- build script.ab    # Disable optimizations
```

### Single Test Development
To work on a specific test file:
```bash
# Run one test from validity suite
cargo test validity::array_compare_equality

# Run tests matching a pattern
cargo test validity::array
```

## Architecture Overview

### Compilation Pipeline

The compiler (`src/compiler.rs`) orchestrates six phases:

1. **Tokenization** - Lexical analysis splits source into tokens
2. **Parsing** - Builds Abstract Syntax Tree (AST) from tokens
3. **Type Checking** - Validates types and resolves symbols
4. **Translation** - Converts AST to Bash code fragments
5. **Optimization** - Removes unused/ephemeral variables
6. **Post-processing** - External validation with `bshchk`

### Key Architectural Patterns

**Trait-Based Phases**: Each AST node implements 4 traits corresponding to compiler phases:
- `SyntaxModule<ParserMetadata>` - Parsing logic
- `TypeCheckModule` - Type checking
- `TranslateModule` - Code generation
- `DocumentationModule` - Documentation

**Fragment-Based Code Generation**: Instead of generating strings directly, the translator builds a tree of `FragmentKind` enums (9 types: Raw, VarExpr, VarStmt, Block, Interpolable, List, Subprocess, Arithmetic, Comment). This structured representation enables optimization passes and context-aware rendering.

**Import System**: Uses topological sort to resolve dependencies and prevent circular imports. The standard library is embedded at compile-time via `include_dir!` macro, eliminating runtime file system dependencies.

**Context Management**: The `amber-meta` procedural macro provides automatic scope management with rollback on error through the `ContextManager` attribute.

### Directory Structure

- **`src/modules/`** - Language constructs (expressions, statements, functions, loops, etc.)
  - Each module implements the 4 core traits
  - Organized by language feature (e.g., `expression/binop/`, `statement/`, `condition/`)

- **`src/translate/`** - AST to Bash translation
  - `fragments/` - 9 fragment types for composable code generation
  - `compute.rs`, `compare.rs` - Arithmetic and comparison operations

- **`src/optimizer/`** - Optimization passes
  - `unused_vars.rs` - Dead code elimination
  - `ephemeral_vars.rs` - Temporary variable removal

- **`src/std/`** - Standard library (written in Amber)
  - `array.ab`, `text.ab`, `fs.ab`, `env.ab`, `date.ab`, `math.ab`, `http.ab`, `test.ab`

- **`src/tests/`** - Integration test suites
  - `validity/` - Correct compilation and execution (467+ tests)
  - `erroring/` - Expected compilation failures
  - `stdlib/` - Standard library functionality
  - `translating/`, `optimizing/`, `warning/` - Phase-specific tests

- **`src/utils/`** - Metadata and utilities
  - `context.rs` - Scoped compilation context
  - `import_cache.rs`, `function_cache.rs` - Dependency tracking
  - `metadata/` - Parser and translation state

### Type System

Amber has 8 types defined in `src/modules/types.rs`:
- `Text` - Strings
- `Num` - Floating point numbers
- `Bool` - Booleans
- `Null` - Null value
- `Int` - Integers (subset of Num)
- `Array[T]` - Homogeneous arrays
- `Generic` - Generic type parameter
- `Failable[T]` - Result type for operations that can fail

### Code Organization Pattern

When adding a new language feature, you typically need to:

1. Create a module in `src/modules/` (e.g., `src/modules/feature/mod.rs`)
2. Implement `SyntaxModule` trait for parsing
3. Implement `TypeCheckModule` trait for type checking
4. Implement `TranslateModule` trait for Bash code generation
5. Add tests in `src/tests/validity/`
6. Update `grammar.ebnf` if it's a new syntax construct

### Testing Infrastructure

**Test Discovery**: Uses `#[test_generator::test_resources()]` macro to find test files.

**Test Format**: Amber test files include expected output in comments:
```amber
// Output
// expected output line 1
// expected output line 2
```

**CI Testing**: GitHub Actions runs tests against Bash versions 3.2-5.3 in Docker containers with both GNU sed and BusyBox sed.

**Snapshot Testing**: Uses `insta` crate with snapshots in `src/tests/snapshots/`.

### Important Implementation Details

**Command Execution**: Amber has special syntax for shell commands:
```amber
$command with {interpolation}$
```
This generates safe Bash with proper escaping through `InterpolableFragment`.

**Statement Queue**: `TranslateMetadata` maintains a `stmt_queue` (VecDeque) allowing expressions to inject statements before themselves - crucial for command modifiers and failable handling.

**Block Types**: Blocks can be single-line (`:`) or multi-line (`{}`), both parsed by `src/modules/block.rs`.

**Postprocessor Pattern**: External tools can validate output. Use `--no-proc "pattern"` to disable (e.g., `--no-proc "b*chk"` disables bshchk validation).

## Development Notes

- The standard library is written in Amber itself (see `src/std/`), demonstrating self-hosting philosophy
- Installation scripts (`setup/install.ab`, `setup/uninstall.ab`) are also written in Amber
- Grammar is documented in `grammar.ebnf` using EBNF notation
- Rust edition 2021, MSRV 1.79
- All profiles (dev/test/release) use opt-level 3 for performance
- The codebase uses `heraclitus-compiler` library as the parser framework
