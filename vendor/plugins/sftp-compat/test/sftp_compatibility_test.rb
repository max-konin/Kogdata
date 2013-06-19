require File.join(File.dirname(__FILE__), '../lib/sftp_compatibility')
require 'test/unit'

module Kernel
  class MockFileForKernel
    def initialize
    end
    def method_missing *args
    end
  end
  def open *args
    return MockFileForKernel.new
  end
  module_function :open
end

class MockResult
  def initialize c, m
    @code, @message = c, m
  end
  def code
    @code
  end
  def message
    @message
  end
end

class MockFile
  def initialize f
    @filename = f
  end
  def filename
    @filename
  end
end

class MockSession < Net::SFTP::Session
  def initialize config = {}
    @config = config
  end
  def method_missing sym, *args
    raise Exception, args.first
  end
  def open_handle *args
    'HANDLE'
  end
  def opendir *args
    'HANDLE'
  end
  def write *args
    MockResult.new(*@config[:result])
  end
  def readdir *args
    @config[:files].map{|f| MockFile.new(f)}
  end
  def close_handle *args
  end
  def get_current_path
    @current_path
  end
end


class SftpCompatibilityTest < Test::Unit::TestCase
  def test_should_make_a_directory_without_complaint
    session = MockSession.new
    begin
      session.mkdir('ralph')
      raise Exception, 'BONK!'
    rescue Exception => e
      assert_equal './ralph', e.message
    end
  end
  
  def test_should_change_directories_up_and_down
    session = MockSession.new
    session.chdir('dennis')
    assert_equal './dennis', session.get_current_path
    session.chdir('denuto')
    assert_equal './dennis/denuto', session.get_current_path
    session.chdir('..')
    assert_equal './dennis', session.get_current_path
    session.chdir('..')
    assert_equal '.', session.get_current_path
  end
  
  def test_should_put_binary_files_without_complaint
    session = MockSession.new :result => [0, '']
    session.putbinaryfile('mine.txt', 'yours.txt')
  end
  def test_should_inexplicably_fail_in_its_attempts_to_write_a_file
    session = MockSession.new :result => [1, 'Clunk!']
    assert_raise StandardError do session.putbinaryfile('mine.txt', 'yours.txt') end
  end
  
  def test_should_gimme_a_file_listing
    session = MockSession.new :files => %w{ a.txt b.txt }
    assert_equal ['a.txt', 'b.txt'], session.nlst
  end
  def test_should_support_empty_file_lists
    session = MockSession.new :files => []
    assert_equal [], session.nlst
  end

  def test_should_allow_removal_of_files_at_current_level
    session = MockSession.new
    session.chdir('dennis')
    begin
      session.delete('denuto.txt')
      raise Exception, 'BONK!'
    rescue Exception => e
      assert_equal './dennis/denuto.txt', e.message
    end
  end

  def test_should_allow_removal_of_directories_at_current_level
    session = MockSession.new
    session.chdir('dennis')
    begin
      session.rmdir('denuto')
      raise Exception, 'BONK!'
    rescue Exception => e
      assert_equal './dennis/denuto', e.message
    end
  end
end
