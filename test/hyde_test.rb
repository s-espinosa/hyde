# $LOAD_PATH.unshift(File.dirname(__FILE__))

lib_folder = File.expand_path(__dir__)
$LOAD_PATH << lib_folder

# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'


class HydeTest < Minitest::Test

  def setup
    @file_path = File.expand_path('~/hyde-test')
    FileUtils.rm_r(@file_path) if File.exists? @file_path
  end

  def test_new_creates_directory
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path)
  end

  def test_auto_delete_is_working
    refute File.exists? File.expand_path(@file_path)
  end

  def test_that_main_css_is_created_in_source
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/css/main.css')
  end

  def test_that_index_markdown_is_created_in_source
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/index.markdown')
  end

  def test_that_about_markdown_is_created_in_source
    submitted = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/pages/about.markdown')
  end

  def test_that_initial_post_markdown_is_created_in_source_with_timestamp
    submitted = `bin/hyde new #{@file_path}`
    timestamp = Time.new.strftime('%Y-%m-%d') + '-'

    assert File.exists? File.expand_path(@file_path + '/source/posts/' + timestamp + 'welcome-to-hyde.markdown')
  end

  def test_that_main_css_is_created_in_output
    create = `bin/hyde new #{@file_path}`
    build  = `bin/hyde build #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/_output/css/main.css')
  end

  def test_that_index_html_is_created_in_output
    create = `bin/hyde new #{@file_path}`
    build  = `bin/hyde build #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/_output/index.html')
  end

  def test_that_about_html_is_created_in_output
    create = `bin/hyde new #{@file_path}`
    build  = `bin/hyde build #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/_output/pages/about.html')
  end

  def test_that_post_html_is_created_in_output_with_timestamp
    create    = `bin/hyde new #{@file_path}`
    build     = `bin/hyde build #{@file_path}`
    timestamp = Time.new.strftime('%Y-%m-%d') + '-'

    assert File.exists? File.expand_path(@file_path + '/_output/posts/' + timestamp + 'welcome-to-hyde.html')
  end

  def test_that_new_markdown_post_with_timestamp_in_source
    post_name = "Long Post Name"
    create    = `bin/hyde new #{@file_path}`
    post      = `bin/hyde post #{@file_path} #{post_name}`
    file_name = Time.new.strftime('%Y-%m-%d') + '-' + post_name.gsub(' ', '-') + '.markdown'

    assert File.exists? File.expand_path(@file_path + '/source/posts/' + file_name)
  end

  def test_that_new_html_post_with_timestamp_in_output
    post_name = "Long Post Name"
    create    = `bin/hyde new #{@file_path}`
    post      = `bin/hyde post #{@file_path} #{post_name}`
    build     = `bin/hyde build #{@file_path}`
    file_name = Time.new.strftime('%Y-%m-%d') + '-' + post_name.gsub(' ', '-') + '.html'

    assert File.exists? File.expand_path(@file_path + '/_output/posts/' + file_name)
  end



  # file name matches ARGS
  # .md file has title content

  # check content matches?
  # post title matches .md and .html content

end
