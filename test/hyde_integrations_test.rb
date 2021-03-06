require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class HydeIntegrationsTest < Minitest::Test

  def setup
    @working_directory = Dir.pwd
    @file_path = File.expand_path(@working_directory + '/test/test-support')
    FileUtils.rm_r(@file_path) if File.exists? @file_path
  end

  def listen
    `osascript -e 'tell app "Terminal"
    do script "cd #{@working_directory} && bin/hyde watchfs #{@file_path}"
    end tell'`
  end

  def test_new_creates_directory
    create = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path)
  end

  def test_auto_delete_is_working
    refute File.exists? File.expand_path(@file_path)
  end

  def test_that_main_css_is_created_in_source
    create = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/css/main.css')
  end

  def test_that_index_markdown_is_created_in_source
    create = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/index.markdown')
  end

  def test_that_about_markdown_is_created_in_source
    create = `bin/hyde new #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/source/pages/about.markdown')
  end

  def test_that_initial_post_markdown_is_created_in_source_with_timestamp
    create    = `bin/hyde new #{@file_path}`
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
    time      = Time.new.strftime('%Y-%m-%d') + '-'
    file_name = time + post_name.split.join('-') + '.markdown'

    assert File.exists? File.expand_path(@file_path + '/source/posts/' + file_name)
  end

  def test_that_new_html_post_with_timestamp_in_output
    post_name = "Long Post Name"
    create    = `bin/hyde new #{@file_path}`
    post      = `bin/hyde post #{@file_path} #{post_name}`
    build     = `bin/hyde build #{@file_path}`
    time      = Time.new.strftime('%Y-%m-%d') + '-'
    file_name = time + post_name.gsub!(' ', '-') + '.html'

    assert File.exists? File.expand_path(@file_path + '/_output/posts/' + file_name)
  end

  def test_html_uses_default_format
    post_name = "Default Formatted Post"
    create    = `bin/hyde new #{@file_path}`
    post      = `bin/hyde post #{@file_path} #{post_name}`
    build     = `bin/hyde build #{@file_path}`
    file_name = Time.new.strftime('%Y-%m-%d') + '-' + post_name.gsub(' ', '-') + '.html'
    expected  = "<html><head><linkrel=\"stylesheet\"type=\"text/css\"href=\"./../css/main.css\">
    <linkrel=\"stylesheet\"type=\"text/css\"href=\"./../css/test.css\">
    <title>OurSite</title></head><body><h1id=\"default-formatted-post\">DefaultFormattedPost</h1>
    <p>Yourcontenthere</p></body></html>"
    actual = File.read File.expand_path(@file_path + '/_output/posts/' + file_name)

    assert_equal expected.scan(/\S/).join, actual.scan(/\S/).join
  end

  def test_listen_watches_file_system
    a_post  = "Initial Post"
    create  = `bin/hyde new #{@file_path}`
    watchfs = listen
    pause   = sleep(1)
    post    = `bin/hyde post #{@file_path} #{a_post}`

    file_name = Time.new.strftime('%Y-%m-%d') + '-' + a_post.gsub(' ', '-') + '.html'
    expected  = "<html><head><linkrel=\"stylesheet\"type=\"text/css\"href=\"./../css/main.css\">
    <linkrel=\"stylesheet\"type=\"text/css\"href=\"./../css/test.css\">
    <title>OurSite</title></head><body><h1id=\"initial-post\">InitialPost</h1>
    <p>Yourcontenthere</p></body></html>"
    pause     = sleep(1)
    actual    = File.read File.expand_path(@file_path + '/_output/posts/' + file_name)

    assert_equal expected.scan(/\S/).join, actual.scan(/\S/).join
  end

  def test_convert_sass_to_css
    create = `bin/hyde new #{@file_path}`
    build  = `bin/hyde build #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/_output/css/test.css')
  end

  def test_move_images_and_other_non_template_files
    create = `bin/hyde new #{@file_path}`
    FileUtils.cp('./test/test_content/turing.jpg', @file_path + '/source/')
    build  = `bin/hyde build #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/_output/turing.jpg')
  end

  def test_convert_haml_to_html
    create = `bin/hyde new #{@file_path}`
    build  = `bin/hyde build #{@file_path}`

    assert File.exists? File.expand_path(@file_path + '/_output/layouts/standard.html')
  end
end
