# coding: utf-8

module Diff
	class CreateBase
		def initialize(aryA, aryB)
			@aryA, @aryB = aryA, aryB
			@diff_ary =	 diff_(aryA,aryB)
		end
		def diff_(aryA,aryB)
			raise "Called abstract method"
		end
		def diff
			@diff_ary
		end
		def diff_slc_format
			slc = []
			a, b = 0, 0
			@diff_ary.each do |diff|
				if diff[0] == "="
					slc << [diff[0], [a, @aryA[a]], [b, @aryB[b]] ]
					a += 1; b += 1
				elsif diff[0] == "-"
					slc << [diff[0], [a, @aryA[a]], [b, "nil"] ]
					a += 1
				elsif diff[0] == "+"
					slc << [diff[0], [a, "nil"], [b, @aryB[b]] ]
					b += 1
				end
			end
			return slc
		end
		def sdiff
			sdiff_ =[]
			@diff_ary.each do | diff |
				sdiff_ << diff if diff[0] != "="
			end
			return sdiff_
		end
	end
end

