#!/usr/bin/ruby
# coding: utf-8

require_relative "./common"

module Diff	
module Wu

	class Create < CreateBase
		def initialize(aryA,aryB)
			super(aryA,aryB)
		end
		def diff_(aryA,aryB)
			diff_(aryB,aryA) if aryA.size > aryB.size
			@A, @B = aryA.clone, aryB.clone
			@M, @N = @A.size, @B.size
			@A.insert(0,""); @B.insert(0,"")

			nodes = FP.new(@M, @N, Node.new(nil, -1, nil) ) # node確保

			de = @N - @M # 最低編集回数

			p = -1 # 削除回数
			# 削除回数ごとに最高到達点fpを計算
			while nodes[de].fp != @N
				p += 1
				(-p).upto(de-1) do |k|
					nodes[k]  = snake( k,  p, nodes[k -1], nodes[k +1] )
				end
				(de+p).downto(de+1) do |k|
					nodes[k]  = snake( k,  p, nodes[k -1], nodes[k +1] )
				end
					nodes[de] = snake( de, p, nodes[de-1], nodes[de+1] )
			end
			# puts "The edit distance is: ", de + 2 * p # 編集回数 
			# Nodesから差分結果を求める。
			best_node = nodes[de]
			p best_node
			result = []
			x, y = nil, nil
			while best_node.fp != -1
				x = best_node.fp - best_node.k 
				y = best_node.fp

				if best_node.prev.fp == -1
					x_prev = 0
					y_prev = 0
				else
					x_prev = best_node.prev.fp - best_node.prev.k
					y_prev = best_node.prev.fp
				end

				puts "aa"
				print x, ", ", y, ", ", x_prev, ", ", y_prev, "\n"
				print @A[x],", ", @B[y], "\n"

				while x > 0 && y > 0
					if x-1 == x_prev && y == y_prev # tate
						result.unshift(["-", x-1, "nil"])
						p result
						break
					elsif x == x_prev && y-1 == y_prev # yoko
						result.unshift(["+", "nil", y-1])
						p result
						break
					end
					result.unshift(["=",x-1,y-1])
					p result
					x-=1; y-=1
					puts "bb"
					print x, ", ", y, ", ", x_prev, ", ", y_prev, "\n"
					print @A[x],", ", @B[y], "\n"
				end
				best_node = best_node.prev
			end
			return result
		end
		class Node
			attr_accessor :k, :fp, :p  # k=x+y, 最高到達点, 削除回数
			attr_accessor :prev
			def initialize(k,fp,p)
				@k, @fp, @p = k, fp, p
			end
		end
		def snake(k, p, node_yoko, node_tate)

			node_prev, y = nil, nil
			if node_yoko.fp + 1 > node_tate.fp
				node_prev = node_yoko
				y = node_yoko.fp + 1
			else
				node_prev = node_tate
				y = node_tate.fp
			end
			x = y - k
			while x < @M && y < @N && @A[x+1] == @B[y+1]
				x+=1; y+=1
			end
			node = Node.new(k, y, p)
			node.prev = node_prev
			return node
		end
=begin
		def diff_(aryA,aryB)
			diff_(aryB,aryA) if aryA.size > aryB.size
			@A, @B = aryA.clone, aryB.clone
			@M, @N = @A.size, @B.size
			de = @N - @M
			@A.insert(0,""); @B.insert(0,"")

			fp = FP.new(@M,@N,-1)

			p = -1 # 削除回数
			# 削除回数ごとに最高到達点fpを計算
			while fp[de] != @N
				p += 1
				(-p).upto(de-1) do |k|
					fp[k]  = snake( k,  [ fp[k -1]+1, fp[k +1]  ].max )
				end
				(de+p).downto(de+1) do |k|
					fp[k]  = snake( k,  [ fp[k -1]+1, fp[k +1]  ].max )
				end
					fp[de] = snake( de, [ fp[de-1]+1, fp[de+1] ].max )
			end
			puts "The edit distance is: ", de + 2 * p # 編集回数 
		end
		def snake(k,y)
			x = y - k
			while x < @M && y < @N && @A[x+1] == @B[y+1]
				x+=1; y+=1
			end
			return y
		end
=end
		class FP
			def initialize(m,n,value)
				@fp = Array.new(m+n+3,value)
				@offset = m + 1
			end
			def [](index)
				return @fp[ @offset + index ]
			end
			def []=(index, value)
				@fp[ @offset + index ] = value
			end
		end
	end
	
end # module Wu
end # moudle Diff	
	