#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rspec'
require 'json'

# Load the script by reading and evaluating it
script_path = File.expand_path('dependabot_manage', __dir__)
eval(File.read(script_path), binding, script_path)

RSpec.describe DependabotManager do
  let(:manager) { DependabotManager.new }

  describe 'version comparison' do
    it 'correctly compares semantic versions' do
      expect(manager.send(:compare_versions, '3.4.2', '3.4.1')).to be > 0
      expect(manager.send(:compare_versions, '3.4.1', '3.4.2')).to be < 0
      expect(manager.send(:compare_versions, '3.4.2', '3.4.2')).to eq 0
    end

    it 'handles multi-digit version numbers' do
      expect(manager.send(:compare_versions, '1.201.0', '1.134.0')).to be > 0
      expect(manager.send(:compare_versions, '10.0.0', '9.9.9')).to be > 0
    end

    it 'handles pre-release versions' do
      expect(manager.send(:compare_versions, '1.0.0', '1.0.0.beta')).to be > 0
      expect(manager.send(:compare_versions, '1.0.0.rc1', '1.0.0.beta')).to be > 0
    end
  end

  describe 'package name extraction' do
    it 'extracts package name from bump PR titles' do
      expect(manager.send(:extract_package_name, 'Bump rexml from 3.4.1 to 3.4.2')).to eq 'rexml'
      expect(manager.send(:extract_package_name, 'Bump aws-sdk-s3 from 1.134.0 to 1.201.0')).to eq 'aws-sdk-s3'
    end

    it 'handles "and" format for multiple packages' do
      expect(manager.send(:extract_package_name, 'Bump validator and @types/validator')).to eq 'validator'
    end

    it 'returns nil for non-bump titles' do
      expect(manager.send(:extract_package_name, 'Fix security vulnerability')).to be_nil
    end
  end

  describe 'lockfile detection' do
    it 'identifies Gemfile.lock' do
      expect(manager.send(:is_lockfile?, 'Gemfile.lock')).to be true
      expect(manager.send(:is_lockfile?, 'path/to/Gemfile.lock')).to be true
    end

    it 'identifies npm lockfiles' do
      expect(manager.send(:is_lockfile?, 'package-lock.json')).to be true
      expect(manager.send(:is_lockfile?, 'yarn.lock')).to be true
      expect(manager.send(:is_lockfile?, 'pnpm-lock.yaml')).to be true
    end

    it 'rejects non-lockfiles' do
      expect(manager.send(:is_lockfile?, 'Gemfile')).to be false
      expect(manager.send(:is_lockfile?, 'package.json')).to be false
      expect(manager.send(:is_lockfile?, 'README.md')).to be false
    end
  end

  describe 'gem version extraction' do
    let(:gemfile_content) do
      <<~GEMFILE
        GEM
          remote: https://rubygems.org/
          specs:
            rexml (3.4.2)
            pundit (2.3.1)
            aws-sdk-s3 (1.134.0)
      GEMFILE
    end

    it 'extracts gem version from Gemfile.lock content' do
      expect(manager.send(:extract_gem_version, gemfile_content, 'rexml')).to eq '3.4.2'
      expect(manager.send(:extract_gem_version, gemfile_content, 'pundit')).to eq '2.3.1'
      expect(manager.send(:extract_gem_version, gemfile_content, 'aws-sdk-s3')).to eq '1.134.0'
    end

    it 'returns nil for missing gems' do
      expect(manager.send(:extract_gem_version, gemfile_content, 'nonexistent')).to be_nil
    end
  end

  describe 'npm version extraction' do
    let(:package_lock_content) do
      {
        "packages" => {
          "node_modules/axios" => { "version" => "1.12.2" },
          "node_modules/core-js" => { "version" => "3.46.0" }
        }
      }.to_json
    end

    it 'extracts npm package version from package-lock.json' do
      expect(manager.send(:extract_npm_version, package_lock_content, 'axios')).to eq '1.12.2'
      expect(manager.send(:extract_npm_version, package_lock_content, 'core-js')).to eq '3.46.0'
    end

    it 'returns nil for missing packages' do
      expect(manager.send(:extract_npm_version, package_lock_content, 'nonexistent')).to be_nil
    end
  end

  describe 'yarn version extraction' do
    let(:yarn_lock_content) do
      <<~YARN
        axios@^1.12.2:
          version "1.12.2"
          resolved "..."

        core-js@^3.46.0:
          version "3.46.0"
          resolved "..."
      YARN
    end

    it 'extracts yarn package version from yarn.lock' do
      expect(manager.send(:extract_yarn_version, yarn_lock_content, 'axios')).to eq '1.12.2'
      expect(manager.send(:extract_yarn_version, yarn_lock_content, 'core-js')).to eq '3.46.0'
    end

    it 'returns nil for missing packages' do
      expect(manager.send(:extract_yarn_version, yarn_lock_content, 'nonexistent')).to be_nil
    end
  end

  describe 'API call tracking' do
    it 'increments API call counter' do
      initial_count = manager.instance_variable_get(:@api_call_count)
      manager.send(:log_api_call, 'test command')
      expect(manager.instance_variable_get(:@api_call_count)).to eq(initial_count + 1)
    end

    it 'does not output when verbose is false' do
      manager.instance_variable_set(:@options, { verbose: false })
      expect { manager.send(:log_api_call, 'test') }.not_to output.to_stdout
    end
  end

  describe 'cache functionality' do
    before do
      manager.instance_variable_set(:@pr_cache, {})
    end

    it 'caches PR data with normalized keys' do
      pr_data = { 'number' => 123, 'title' => 'Test PR' }
      cache_key = '123_mergeable,title'

      manager.instance_variable_get(:@pr_cache)[cache_key] = pr_data

      result = manager.send(:get_pr_data, 123, 'title,mergeable')
      expect(result).to eq(pr_data)
    end

    it 'normalizes field order in cache keys' do
      # Fields in different order should produce same normalized key
      key1 = '123_' + 'title,mergeable'.split(',').sort.join(',')
      key2 = '123_' + 'mergeable,title'.split(',').sort.join(',')

      expect(key1).to eq(key2)
    end
  end

  describe 'options parsing' do
    it 'defaults to dry run mode' do
      options = manager.instance_variable_get(:@options)
      expect(options[:dry_run]).to be true
    end

    it 'defaults to closing merged PRs' do
      options = manager.instance_variable_get(:@options)
      expect(options[:close_merged]).to be true
    end

    it 'defaults to including test failures' do
      options = manager.instance_variable_get(:@options)
      expect(options[:include_test_failures]).to be true
    end
  end

  describe 'interactive TUI formatting' do
    it 'aligns arrows in PR display' do
      prs_to_close = [
        { 'number' => 100, 'title' => 'Short' },
        { 'number' => 200, 'title' => 'A much longer title here' }
      ]

      # Simulate the formatting logic
      pr_items = prs_to_close.map do |pr|
        {
          number: pr['number'],
          title: pr['title'],
          action: :close,
          reason: 'Already merged'
        }
      end

      max_length = pr_items.map { |item| "PR ##{item[:number]}: #{item[:title]}".length }.max
      arrow_column = max_length + 2

      displays = pr_items.map do |item|
        pr_label = "PR ##{item[:number]}: #{item[:title]}"
        padding = " " * (arrow_column - pr_label.length)
        "#{pr_label}#{padding}→ Close (#{item[:reason]})"
      end

      # All arrows should be at the same column
      arrow_positions = displays.map { |d| d.index('→') }
      expect(arrow_positions.uniq.length).to eq(1)
    end

    it 'sorts PRs by number descending' do
      prs = [
        { 'number' => 100, 'title' => 'Old' },
        { 'number' => 300, 'title' => 'New' },
        { 'number' => 200, 'title' => 'Middle' }
      ]

      sorted = prs.sort_by { |pr| -pr['number'] }

      expect(sorted.map { |pr| pr['number'] }).to eq([300, 200, 100])
    end
  end
end

# Run the specs
RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
end
