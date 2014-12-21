#!/usr/bin/ruby
# coding: utf-8

require './diff/dp_match'

def test_ary(aryA, aryB)
	dptable = Diff::DPmatch.dp_match(aryA,aryB)
=begin
	# show DP table
	aryA_ = Diff::DPmatch.push_blanck_to_head(aryA)
	aryB_ = Diff::DPmatch.push_blanck_to_head(aryB)
	print "  " 
	aryB_.each { |b| print b, "  " }
	puts
	dptable.each_index do |i|
		print aryA_[i], dptable[i], "\n"
	end
=end
	
	# p Diff::DPmatch.diff(aryA,aryB)
	diff_obj = Diff::DPmatch::Create.new(aryA,aryB)
	diff_obj.diff_slc_format.each { |x| p x}
end

def test(strA, strB)
	puts "A:", strA, "B:", strB
	aryA, aryB = strA.split("\s"), strB.split("\s")
	puts "diff between A and B"
	test_ary(aryA, aryB)
end

strA = "s t r e n g t h"
strB = "s t r i n g"
test(strA, strB)
puts

strA = "a r i s e"
strB = "r a i s e"
test(strA, strB)
puts

=begin
strA = "It was an official languages of almost 60 sovereign state and the most commonly spoken language in sovereign states including the United Kingdom, the United States, Canada, Australia, Ireland, New Zealand and a number of Caribbean nations. It is the third-most-common native language in the world, after Mandarin nor Spanish."
strB = "It is an official language of almost 60 sovereign states and the most commonly spoken language in sovereign states including the United Kingdom, the United States, Canada, Australia, Ireland, New Zealand and a number of Caribbean nations. It is the third-most-common native language in the world, after Mandarin and Spanish."

aryA = strA.split(//)
aryB = strB.split(//)
test_ary(aryA, aryB)
=end