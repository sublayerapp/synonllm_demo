# Synonllm

Synonllm is a Ruby module that provides intelligent method calling through AI-powered synonym matching. When you call a method that doesn't exist, it uses Large Language Model analysis to suggest and automatically call semantically similar existing methods.

## How It Works

When `method_missing` is triggered, Synonllm:

1. Captures the called method name, arguments, and available methods on the class
2. Analyzes the source code context using Gemini AI
3. Suggests the most likely intended method based on semantic similarity
4. Automatically calls the suggested method if confidence is high enough

## Installation

Add this to your Ruby project:

```ruby
require_relative "synonllm"
```

## Usage

Include the `Synonllm` module in any class where you want intelligent method suggestion:

```ruby
class MyClass
  include Synonllm
  
  def fetch_data
    "some data"
  end
end

obj = MyClass.new
obj.get_data  # Automatically calls fetch_data if AI determines it's a good match
```

### Real Examples

#### Date Enhancement
```ruby
require_relative "synonllm"

date = Date.new(1995, 12, 21)
Date.include(Synonllm)

# Calling day_of_week (doesn't exist) might suggest wday (does exist)
day_number = date.day_of_week  # AI suggests calling date.wday
```

#### File Handler
```ruby
class FileHandler
  include Synonllm

  def open_the_file_at_the_given_path_and_return_a_file_object(filepath)
    File.open(filepath)
  end
end

handler = FileHandler.new
# Short method names are intelligently mapped to verbose ones
handler.get_file_at("./file.txt")  # AI suggests the long method name
```

## Configuration

### AI Provider
Synonllm uses Gemini 2.0 Flash by default. The AI provider is configured automatically when the module is used. You can change the AI provider by modifying the `Sublayer` configuration if needed or by building your own custom Sublayer provider.

### Debug Mode
Enable debug output to see the AI's analysis:

```bash
DEBUG=1 ruby your_script.rb
```

This will show:
- Detailed analysis of what the user was trying to do
- The suggested method name
- Confidence score (0-100)

## How the AI Makes Decisions

The AI considers multiple factors when suggesting methods:

- **Semantic similarity**: "remove" vs "delete", "get" vs "fetch"
- **Common abbreviations**: "desc" vs "description", "auth" vs "authenticate"
- **Pluralization differences**: "user" vs "users"
- **Argument compatibility**: Whether the arguments match expected parameters
- **Ruby naming conventions**: Standard patterns in Ruby method naming

### Confidence Scoring
- **90-100**: Almost certain match (very similar names, same functionality)
- **70-89**: Likely match (similar purpose, compatible arguments)
- **50-69**: Possible match (related functionality but some differences)
- **Below 50**: Weak match or no suitable alternative

## Dependencies

- `sublayer` gem for LLM integration
- Access to Gemini AI (configured automatically)

## Examples

Run the included examples:

```bash
# Date example - shows method name suggestions for Date class
ruby date/enhanced_date.rb

# File handling example - shows verbose method name mapping
ruby file_handling/file_example.rb

# Enable debug output to see AI analysis
DEBUG=1 ruby date/enhanced_date.rb
```

## How It Works Internally

1. **Method Missing Hook**: When a non-existent method is called, `method_missing` is triggered
2. **Context Capture**: The system captures:
   - The called method name
   - Arguments passed
   - Available methods on the class
   - Source code of the class
3. **AI Analysis**: A Sublayer-based generator analyzes the context using Gemini AI
4. **Smart Suggestion**: The AI provides a method suggestion with confidence score
5. **Automatic Execution**: If confidence is sufficient, the suggested method is called

## License

See LICENSE file for details.
