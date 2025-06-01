# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Ruby module called Synonllm that provides intelligent method suggestion through AI-powered synonym matching. The core functionality uses LLM analysis to suggest alternative method names when Ruby's `method_missing` is triggered.

### Key Components

- **SynonymMethodGenerator**: A Sublayer-based generator that analyzes failed method calls and suggests semantically similar existing methods using Gemini AI
- **Synonllm module**: The main mixin that overrides `method_missing` to provide intelligent method suggestion
- **Source code introspection**: Captures and analyzes the source file of classes that include the module

### Core Flow

1. When a method is called that doesn't exist, `method_missing` is triggered
2. The system captures the called method name, arguments, and available methods on the class
3. An LLM analyzes the context and suggests the most likely intended method
4. If confidence is high enough, the suggested method is automatically called

## Development Commands

This is a pure Ruby project without a formal build system. Run examples directly:

```bash
# Run the date example
ruby date/enhanced_date.rb

# Run the file handling example  
ruby file_handling/file_example.rb

# Enable debug output for LLM analysis
DEBUG=1 ruby date/enhanced_date.rb
```

## Dependencies

- Requires the `sublayer` gem for LLM integration
- Uses Gemini 2.0 Flash model for analysis
- No formal dependency management (Gemfile) detected

## Testing

Run examples in the `date/` and `file_handling/` directories to test functionality. Enable `DEBUG=1` environment variable to see LLM analysis output.
