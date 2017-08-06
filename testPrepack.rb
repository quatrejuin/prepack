#!/usr/bin/ruby
# 3 @ $6.99 5 @ $8.99
VS5_PACK = Array[3,5]
# 2 @ $9.95 5 @ $16.95 8 @ $24.95
MB11_PACK = Array[2,5,8]
# 3 @ $5.95 5 @ $9.95 9 @ $16.99
CF_PACK = Array[3,5,9]


def testPrepack (nums,packs,total)
  # if the member of nums and packs mismatched
  if nums.count != packs.count
    return false
  else
    cal_total = 0
    packs.each_index {|i| cal_total+=nums[i]*packs[i]}
    return cal_total==total
  end
end


TEST_DATA=[ \
	{total:10,packs:[5,3],numpacks:[2,0]}, \
	{total:14,packs:[8,5,2],numpacks:[1,0,3]}, \
	{total:13,packs:[9,5,3],numpacks:[0,2,1]}, \
	{total:34,packs:[20,16,8,5,2],numpacks:[0,2,0,0,1]}, \
{total:27,packs:[13,8,5,2],numpacks:[1,1,0,3]}, \
{total:19,packs:[8,5,2],numpacks:[1,1,3]} \
]
def testProduct ()
	result= true
	TEST_DATA.each do |test|
		puts
		puts "---"
		result= (iniPrePackNew(test[:packs],test[:total])==test[:numpacks]) && result
		print "#{test}-#{result}-#{iniPrePackNew(test[:packs],test[:total])}"
		puts
	end
	return result
end




def prePackNew(packs,total,packs_in=[],packs_pop=[])
	packs = packs.dup
	# print packs
	# print total
	# print packs_in
	# print packs_pop
	# puts
    
   if  total==0
    	return true
	elsif packs.count<1 
		if packs_in.count >0
			r=packs_in.pop
			$num_packs[r]-=1
			# pop out the value less than r from packs_pop
			popout=[]
			packs_pop.reverse.each do |p|
				if p<r
					popout.unshift(packs_pop.pop) 
				end
			end
			return prePackNew(popout,total+r,packs_in,packs_pop)
		else
			$num_packs={}
			return false
		end
	elsif (total<packs[0])
		p = packs.shift
		packs_pop.push(p)
		return prePackNew(packs,total,packs_in,packs_pop)
	elsif (total>=packs[0])
		if packs_in.nil?
			packs_in=[]
		end
		packs_in.push(packs[0])
		$num_packs[packs[0]]=($num_packs[packs[0]].nil?)?1:($num_packs[packs[0]]+1)
		return prePackNew(packs,total-packs[0],packs_in,packs_pop)
	end
end

def iniPrePackNew (packs,total,packs_in=[],packs_pop=[])
	num_packs_all=[]
	result = false
	packs_itr = packs.dup
	packs.each_index do |i|
		$num_packs={}
		result= prePackNew(packs_itr,total) || result
		num_packs_all.push($num_packs)
		packs_itr.shift
	end
			# complete the results hash and sort it (desendant)
		num_packs_all=num_packs_all.collect do |n|
			packs.each {|p| n.has_key?(p)?0:n[p]=0}
			n.sort{|x,y|y<=>x}.to_h
		end
		# convert hash to array
		num_packs_a=[]
		num_packs_all.each do |n|
    		if n.values.reduce(:+)>0
    			num_packs_a.push(n.values)
    		end
		end
	# print num_packs_all
	# puts
	if result
		# calculate the sum and find record correspond to the minimum of the sum
		return num_packs_a[num_packs_a.map {|i| i.reduce(:+)}.each_with_index.min[1]]
	else
		return false
	end
end


#print "min_packs_num=#{iniPrePackNew([2,5,8,16,20],34)}\n"
testProduct()