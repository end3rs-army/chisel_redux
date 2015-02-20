require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './chisel'

class ChiselTest < Minitest::Test 

	def test_this_file_works
		
		assert true
	end

	def test_it_reads_in_a_string
		chi = Chisel.new("string")
		assert_equal "string",chi.doc
	end

	def test_it_splits_multi_line_string
		chi = Chisel.new("This is a
							second line")
		chi.split
		assert_equal ["This is a", "\t\t\t\t\t\t\tsecond line"],chi.sentances
	end

	def test_it_separates_lines_into_a_hash
		chi = Chisel.new("This is a
							second line")
		chi.split
		chi.doc_hash
		assert_equal ["\t\t\t\t\t\t\t", "second", " ", "line", ""],chi.lines[1]
	end

	def test_it_can_recognize_and_format_headers
		chi = Chisel.new("# This is a Header")
		chi.split
		chi.doc_hash
		chi.head_format
		assert_equal ["<h1>", " ", "This", " ", "is", " ", "a", " ", "Header", "", "</h1>"],chi.lines[0]
	end

	def test_it_can_format_for_strong
		chi = Chisel.new("**This **is** strong**")
		chi.split
		chi.doc_hash
		chi.strong_format
		result = chi.lines[0]
		assert_equal ["<strong>This", " ", "<strong>is</strong>", " ", "strong</strong>", ""],result
	end

	def test_it_can_format_number_bullets
		chi = Chisel.new("4. a bullet")
		chi.doc_hash
		chi.split
		chi.doc_hash
		chi.number_bullet_format
		result = chi.lines[0]
		assert_equal ["<l>", " ", "a", " ", "bullet", "", "</l>"],result
	end

	def test_it_can_format_regular_bullets
		chi = Chisel.new("* a star bullet")
		chi.doc_hash
		chi.split
		chi.doc_hash
		chi.bullet_format
		result = chi.lines[0]
		assert_equal ["<l>", " ", "a", " ", "star", " ", "bullet", "", "</l>"],result
	end

	def test_it_can_format_paragraphs
		skip
		chi = Chisel.new("
							This is my
							awesome paragraph")
		chi.doc_hash
		chi.split
		chi.doc_hash
		chi.para_collect
		result = chi.lines(1)
		assert_equal [5],result
	end

	def test_it_can_format_em
		chi = Chisel.new("*WOW*")
		chi.split
		chi.doc_hash
		chi.em_format
		result = chi.lines[0]
		assert_equal ["<em>WOW</em>", ""],result
	end

	def test_it_can_trim_empty_strings_from_arrays
		chi = Chisel.new("# This is a Header")
		chi.split
		chi.doc_hash
		chi.head_format
		chi.tidy_up
		result = chi.lines[0]
		assert_equal ["<h1>", "This", " ", "is", " ", "a", " ", "Header", "", "</h1>"],result
	end
end