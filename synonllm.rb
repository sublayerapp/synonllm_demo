require "sublayer"

class SynonymMethodGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :named_strings,
    name: "synonym_analysis",
    description: "Analysis of method call and potential synonym match",
    attributes: [
      { name: "analysis", description: "Detailed analysis of what the user was trying to do and whether a suitable method exists" },
      { name: "method_to_call", description: "The name of the method to call that we will convert into a symbol" },
      { name: "confidence_score", description: "Confidence score from 0-100 indicating how confident the analysis is that this was what the user meant to call" }
    ]

  def initialize(called_method:, arguments:, source_code:, available_methods:)
    @called_method = called_method
    @arguments = arguments
    @source_code = source_code
    @available_methods = available_methods
  end

  def generate
    Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
    Sublayer.configuration.ai_model = "gemini-2.0-flash"
    super
  end

  def prompt
    <<-PROMPT
    You are an expert Ruby developer analyzing a method call that resulted in a NoMethodError.
    Your task is to determine if the user was trying to call a different method that exists on the class,
    based on semantic similarity and common naming patterns.

    Called method: #{@called_method}
    Arguments passed: #{@arguments.inspect}

    Available methods on the class:
    #{@available_methods.join(", ")}

    Source code of the class:
    #{@source_code}

    Please analyze:
    1. What the user was likely trying to accomplish based on the method name and arguments
    2. Whether any of the available methods could serve the same purpose
    3. Consider common synonyms, abbreviations, and naming conventions in Ruby

    For the analysis, provide:
    - A detailed explanation of your reasoning
    - The most likely method they meant to call (or "none" if no suitable match exists)
    - A confidence score from 0-100

    Consider these factors for matching:
    - Semantic similarity (e.g., "remove" vs "delete", "get" vs "fetch")
    - Common abbreviations (e.g., "desc" vs "description", "auth" vs "authenticate")
    - Pluralization differences (e.g., "user" vs "users")
    - Common typos or naming variations
    - Whether the arguments match the expected parameters of potential methods

    Be conservative with your confidence score:
    - 90-100: Almost certain match (very similar names, same functionality)
    - 70-89: Likely match (similar purpose, compatible arguments)
    - 50-69: Possible match (related functionality but some differences)
    - Below 50: Weak match or no suitable alternative
    PROMPT
  end
end

module Synonllm
  def method_missing(method_name, *args, &block)
    synonym_method_generator = SynonymMethodGenerator.new(
      called_method: method_name,
      arguments: args,
      source_code: self.class.source_file_contents,
      available_methods: self.methods - Object.methods - [:method_missing, :respond_to_missing?]
    )
    results = synonym_method_generator.generate
    if ENV['DEBUG']
      puts "Analysis: #{results.analysis}"
      puts "Method name suggested: #{results.method_to_call}"
      puts "Confidence score: #{results.confidence_score}"
    end
    synonym_method_name = results.method_to_call

    self.send(synonym_method_name.to_sym, *args) if synonym_method_name != 'none'
  end

  def self.included(base)
    base.instance_variable_set(:@source_file, caller_locations.first.path)
    base.extend ClassMethods
  end

  module ClassMethods
    def source_file_contents
      File.read(@source_file) if @source_file
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end
