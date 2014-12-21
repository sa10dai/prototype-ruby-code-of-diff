#!/usr/bin/ruby
# coding: utf-8

require "./diff/common"

module Diff	
module DPmatch
	
	def dist(chr1, chr2)
		return chr1.to_s == chr2.to_s ? 0:1
	end

	def dp_match(aryA,aryB)
		aryA.insert(0," "); aryB.insert(0," ")

		lenA, lenB = aryA.length, aryB.length
		
		dptable = Array.new(lenA){ Array.new(lenB) }

		# 端を埋める 
		dptable[0][0] = dist( aryA[0], aryB[0] )
		1.upto(lenA-1) { |i| dptable[i][0] = dist(aryA[i], aryB[0]) + dptable[i-1][0] }
		1.upto(lenB-1) { |j| dptable[0][j] = dist(aryA[0], aryB[j]) + dptable[0][j-1] }
		
		# スコア表を作成
		1.upto(lenA-1) do |i|
			1.upto(lenB-1) do |j|
				# 現在の位置の距離
				dist = dist( aryA[i], aryB[j] )	
				# 現在の位置へとかかるコストをハッシュ
				costs = { :tate=>dptable[i-1][j] + dist,
					 :yoko=>dptable[i][j-1] + dist,
					 :naname=>dptable[i-1][j-1] + dist }
				# 文字が同じ場合は斜め移動を選択、それ以外は最小値
				if dist == 0
					dptable[i][j] = costs[:naname]
				elsif 
					dptable[i][j] = ( costs[:yoko] < costs[:tate] ? costs[:yoko]:costs[:tate] )
				end
			end 
		end
		aryA.delete_at(0); aryB.delete_at(0)	
		return dptable	
	end
	
	PATH = { :tate=>[1,0], :yoko=>[0,1], :naname=>[1,1] }

	def diff(aryA, aryB)
		dptable = dp_match(aryA, aryB)
		aryA.insert(0, " "); aryB.insert(0, " ")
		
		lenA, lenB = aryA.length, aryB.length			
		
		global_best_path = []
		
		# 右下隅から探索
		i, j = lenA-1, lenB-1
		while i != 0 || j != 0 
		# (i,j) = (0,0)にならないと終了しない。
			costs = { :tate=>dptable[i-1][j] ,
				  :yoko=>dptable[i][j-1],
				  :naname=>dptable[i-1][i-1] }

			best_path = :naname
			if i == 0
				best_path = :yoko
			elsif j == 0
				best_path = :tate
			elsif dist(aryA[i], aryB[j]) != 0
				best_path = ( costs[:tate] < costs[:yoko] ? :tate : :yoko )
			end
			global_best_path << PATH[best_path]
			i -= PATH[best_path][0]
			j -= PATH[best_path][1]
		end
		
		# global pathから差分を得る。
		result = []
		a, b = 1, 1
		n = global_best_path.size
		1.upto(n) do |i|
			best_path = global_best_path[n-i]
			if best_path == PATH[:naname]
				result << ["=", a-1, b-1]
				a += 1
				b += 1
			elsif best_path == PATH[:tate] 
				result << ["-", a-1, "nil"]
				a += 1
			elsif best_path == PATH[:yoko]
				result << ["+", "nil", b-1 ]
				b += 1
			end		
		end
		aryA.delete_at(0)
		aryB.delete_at(0)
		return result
	end	
	module_function :dist, :dp_match, :diff

	class Create < CreateBase
		def initialize(aryA,aryB)
			super(aryA,aryB)
		end
		def diff_(aryA,aryB)
			DPmatch.diff(aryA,aryB)
		end
	end
end
end

